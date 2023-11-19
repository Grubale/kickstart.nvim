-- treesj.lua

return {
  'Wansmer/treesj',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    use_default_keymaps = false,
  },
  keys = {
    { '<leader>i', mode = 'n', function() require('treesj').toggle() end, desc = 'Toggle split/join' },
  },
}
