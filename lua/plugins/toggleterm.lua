-- toggleterm.lua

return {
  'akinsho/toggleterm.nvim',
  dependencies = {
    'folke/which-key.nvim',
  },
  cmd = { "ToggleTerm", "TermExec" },
  event = 'VimEnter',
  opts = function(_, opts)
    require('which-key').register({
      t = {
        name = ' ToggleTerm',
        f = { '<cmd>ToggleTerm direction=float<cr>', 'ToggleTerm float' },
        h = { '<cmd>ToggleTerm size=10 direction=horizontal<cr>', 'ToggleTerm horizontal split' },
        v = { '<cmd>ToggleTerm size=80 direction=vertical<cr>', 'ToggleTerm vertical split' },
        l = { function() require('utils').toggle_term_cmd 'lazygit' end, 'ToggleTerm LazyGit' },
      },
    }, { prefix = '<leader>' })

    opts.size = 10
    opts.on_create = function()
      vim.opt.foldcolumn = "0"
      vim.opt.signcolumn = "no"
    end
    opts.open_mapping = [[<F7>]]
    opts.shading_factor = 2
    opts.direction = "float"
    opts.float_opts = { border = "rounded" }

    return opts
  end,
}
