-- illuminate.lua

return {
  'RRethy/vim-illuminate',
  dependencies = {
    'folke/which-key.nvim',
  },
  config = function ()
    require('illuminate').configure({
      filetypes_denylist = {
          'dirbuf',
          'dirvish',
          'fugitive',
          'neo-tree',
      },
    })

    vim.keymap.del({ 'o', 'x' }, '<a-i>')

  end,
}
