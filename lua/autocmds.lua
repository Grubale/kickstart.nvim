-- @module utils.autocmds

-- [[ Update buffers ]]
local bufferline_group = vim.api.nvim_create_augroup("bufferline", { clear = true })
vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "TabNewEntered", "TabClosed" }, {
  desc = "Update buffers when adding new buffers",
  group = bufferline_group,
  callback = function(args)
    local buf_utils = require "utils.buffer"
    if not vim.t.bufs then vim.t.bufs = {} end
    if not buf_utils.is_valid(args.buf) then return end
    if args.buf ~= buf_utils.current_buf then
      buf_utils.last_buf = buf_utils.is_valid(buf_utils.current_buf) and buf_utils.current_buf or nil
      buf_utils.current_buf = args.buf
    end
    local bufs = vim.t.bufs
    if not vim.tbl_contains(bufs, args.buf) then
      table.insert(bufs, args.buf)
      vim.t.bufs = bufs
    end
    vim.t.bufs = vim.tbl_filter(buf_utils.is_valid, vim.t.bufs)
  end,
})

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Delete trailing whitespaces ]]
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  command = [[%s/\s\+$//e]],
})
