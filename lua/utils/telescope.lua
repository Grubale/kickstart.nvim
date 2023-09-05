-- @module utils.telescope

local M = {}
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")

local function getPreviewer(opts)
  if opts.show_preview then
    return conf.file_previewer(opts)
  else
    return nil
  end
end

local function close(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local original_win_id = picker.original_win_id
  local cursor_valid, original_cursor = pcall(vim.api.nvim_win_get_cursor, original_win_id)

  actions.close_pum(prompt_bufnr)

  require("telescope.pickers").on_close_prompt(prompt_bufnr)
  pcall(vim.api.nvim_set_current_win, original_win_id)
  if cursor_valid and vim.api.nvim_get_mode().mode == "i" and picker._original_mode ~= "i" then
    pcall(vim.api.nvim_win_set_cursor, original_win_id, { original_cursor[1], original_cursor[2] + 1 })
  end
end

local function getDirFindCommand()
  return { 'fd', '--type', 'd', '--color', 'never', '--exclude', 'node_modules', '--exclude', '.git'}
end

local function getExtFindCommand()
  return "rg --files --color never -g '!node_modules' -g '!.git'"
end

function M.buffers()
  require('telescope.builtin').buffers({
    ignore_current_buffer = true,
    attach_mappings = function (_, map)
      map({'n', 'i'}, '<C-x>', function ()
        local selection = action_state.get_selected_entry()

        vim.api.nvim_buf_delete(selection.bufnr, { force = true })
      end)

      return true
    end
  })
end

function M.ext_picker(opts, fn)
  local find_command = getExtFindCommand()
  local search_dirs = opts.search_dirs

  if opts.hidden then
    find_command = find_command .. ' --hidden'
  end

  if opts.no_ignore then
    find_command = find_command .. ' --no-ignore'
  end

  if opts.no_ignore_parent then
    find_command = find_command .. ' --no-ignore-parent'
  end

  if search_dirs then
    for k, v in pairs(opts.search_dirs) do
      search_dirs[k] = vim.fn.expand(v)
    end

    for _, dir in pairs(search_dirs) do
      find_command = find_command .. ' ' .. dir
    end
  end

  local additional_options = { '|', 'gawk', "'match($0, /(\\.)([^\\.\\/]*)$/, arr) {print arr[2]}'", '|', 'sort', '|', 'uniq' }

  for _, option in pairs(additional_options) do
    find_command = find_command .. ' ' .. option
  end

  vim.fn.jobstart(find_command, {
    stdout_buffered = true,
    on_stdout = function (_, data)
      if data then
        pickers.new(opts, vim.tbl_extend('force', require('telescope.themes').get_dropdown { previewer = false, winblend = 10 }, {
          prompt_title = 'Select a Filetype',
          finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file(opts) }),
          sorter = conf.file_sorter(opts),
          attach_mappings = function (prompt_bufnr)
            actions.close:replace(function ()
              close(prompt_bufnr)

              fn(opts)
            end)

            action_set.select:replace(function ()
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local additional_args = {}
              local selections = current_picker:get_multi_selection()

              if vim.tbl_isempty(selections) then
                if action_state.get_selected_entry().value == 'scss' then
                  additional_args[#additional_args + 1] = '--type=sass'
                elseif action_state.get_selected_entry().value == 'yml' then
                  additional_args[#additional_args + 1] = '--type=yaml'
                elseif action_state.get_selected_entry().value ~= '' then
                  additional_args[#additional_args + 1] = '--type=' .. action_state.get_selected_entry().value
                end
              else
                for _, selection in ipairs(selections) do
                  if selection.value == 'scss' then
                    additional_args[#additional_args + 1] = '--type=css'
                  elseif selection.value == 'yml' then
                    additional_args[#additional_args + 1] = '--type=yaml'
                  else
                    additional_args[#additional_args + 1] = '--type=' .. selection.value
                  end
                end
              end

              close(prompt_bufnr)

              if type(opts.additional_args) == 'function' then
                opts.additional_args = opts.additional_args(additional_args)
              else
                opts.additional_args = function (args)
                  return vim.list_extend(args, additional_args)
                end
              end

              fn(opts)
            end)
            return true
          end
        })):find()
      else
        vim.notify('No files found', vim.log.levels.ERROR)
      end
    end
  })
end

function M.dir_picker(opts, fn, live_grep)
  local find_command = getDirFindCommand()
  local command = find_command[1]
  local hidden = opts.hidden
  local no_ignore = opts.no_ignore
  local no_ignore_parent = opts.no_ignore_parent

  if command == 'fd' or command == 'fdfind' or command == 'rg' then
    if hidden then
      find_command[#find_command + 1] = '--hidden'
    end

    if no_ignore then
      find_command[#find_command + 1] = '--no-ignore'
    end

    if no_ignore_parent then
      find_command[#find_command + 1] = '--no-ignore-parent'
    end
  else
    vim.notify('telescope: You need to install either find, fd/fdfind or ripgrep', vim.log.levels.ERROR)
  end

  vim.fn.jobstart(find_command, {
    stdout_buffered = true,
    on_stdout = function (_, data)
      if data then
        pickers.new(opts, {
          prompt_title = 'Select a Directory',
          finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file(opts) }),
          previewer = getPreviewer(opts),
          sorter = conf.file_sorter(opts),
          attach_mappings = function (prompt_bufnr)
            actions.close:replace(function ()
              close(prompt_bufnr)

              if live_grep then
                M.ext_picker(opts, fn)
              else
                fn(opts)
              end
            end)

            action_set.select:replace(function ()
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local dirs = {}
              local selections = current_picker:get_multi_selection()

              if vim.tbl_isempty(selections) then
                if action_state.get_selected_entry().value ~= '' then
                  table.insert(dirs, action_state.get_selected_entry().value)
                end
              else
                for _, selection in ipairs(selections) do
                  table.insert(dirs, selection.value)
                end
              end

              close(prompt_bufnr)

              opts.search_dirs = dirs

              if live_grep then
                M.ext_picker(opts, fn)
              else
                fn(opts)
              end
            end)
            return true
          end
        }):find()
      else
        vim.notify('No directories found', vim.log.levels.ERROR)
      end
    end
  })
end

return M
