-- neo_tree.lua

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = "main", -- HACK: force neo-tree to checkout `main` for initial v3 migration since default branch has changed
  dependencies = {
    'MunifTanjim/nui.nvim',
    'folke/which-key.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  },
  cmd = "Neotree",
  init = function() vim.g.neo_tree_remove_legacy_commands = true end,
  opts = function()
    return {
      auto_clean_after_session_restore = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      close_if_last_window = true,
      sources = { 'filesystem' },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = " File" },
        },
      },
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 0,
          highlight = "NeoTreeIndentMarker",
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '',
          folder_empty_open = '',
          default = '󰈙',
        },
        modified = {
          symbol = '󰏪',
        },
        name = {
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            added = '',
            deleted = '',
            modified = '',
            renamed = '➜',
            untracked = '★',
            ignored = '◌',
            unstaged = '✗',
            staged = '✓',
            conflict = '',
          },
        },
      },
      commands = {
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            require('utils').notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
          }, function(choice)
            local result = vals[choice]
            if result then
              require('utils').notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
        find_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require("telescope.builtin").find_files {
            cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
          }
        end,
      },
      window = {
        position = "float",
        width = 40,
        mappings = {
          ["<space>"] = false, -- disable space until we figure out which-key disabling
          F = "find_in_dir",
          S = "open_split",
          s = "open_vsplit",
          P = "toggle_preview",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ["<C-j>"] = "move_cursor_down",
          ["<C-k>"] = "move_cursor_up",
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          never_show = {
            '.DS_Store',
          },
        },
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_) vim.opt_local.signcolumn = "auto" end,
        },
      },
    }
  end,
}
