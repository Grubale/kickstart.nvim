-- treesitter.lua

return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
  },
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')

    configs.setup({
      auto_install = false,
      sync_install = true,
      ignore_install = {},
      modules = {},
      autotag = {
        enable = true
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-G>',
          node_incremental = '<C-G>',
          node_decremental = '<C-Q>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ["ar"] = '@loop.outer',
            ["ir"] = '@loop.inner',
            ["ae"] = '@conditional.outer',
            ["ie"] = '@conditional.inner',
          },
          selection_modes = {
            ["@function.outer"] = "V",
            ["@function.inner"] = "V",
            ["@class.outer"] = "V",
            ["@class.inner"] = "V",
            ["@parameter.outer"] = "v",
            ["@parameter.inner"] = "v",
            ["@loop.outer"] = "V",
            ["@loop.inner"] = "V",
            ["@conditional.outer"] = "V",
            ["@conditional.inner"] = "V",
          },
          include_surrounding_whitespace = function(opts)
            return opts["query_string"] == "@parameter.outer"
          end,
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
      ensure_installed = {
        'bash',
        'css',
        'csv',
        'diff',
        'dockerfile',
        'fish',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'html',
        'ini',
        'javascript',
        'json',
        'lua',
        'passwd',
        'php',
        'phpdoc',
        'regex',
        'scss',
        'sql',
        'toml',
        'tsx',
        'vue',
        'xml',
        'yaml',
      },
    })
  end,
}
