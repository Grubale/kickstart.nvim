-- git_blame.lua

return {
  'f-person/git-blame.nvim',
  dependencies = {
    'folke/which-key.nvim',
  },
  opts = function (_, opts)
    require('which-key').register({
      G = {
        name = ' Git blame',
        o = { '<cmd>GitBlameOpenCommitURL<cr>', 'Open commit url' },
        h = { '<cmd>GitBlameCopySHA<cr>', 'Copy commit SHA' },
        u = { '<cmd>GitBlameCopyCommitURL<cr>', 'Copy commit url' },
        f = { '<cmd>GitBlameOpenFileURL<cr>', 'Open file url' },
      },
    }, { prefix = '<leader>'})

    return opts
  end,
  event = 'VeryLazy',
}
