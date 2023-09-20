-- noice.lua

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'folke/which-key.nvim',
    'MunifTanjim/nui.nvim',
  },
  opts = function(_, opts)
    vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
      if not require("noice.lsp").scroll(4) then
        return "<c-f>"
      end
    end, { silent = true, expr = true })

    vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
      if not require("noice.lsp").scroll(-4) then
        return "<c-d>"
      end
    end, { silent = true, expr = true })

    return vim.tbl_deep_extend('force', opts, {
      cmdline = {
        format = {
          search_down = { icon = ' ' },
          search_up = { icon = ' ' },
        },
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      views = {
        cmdline_popup = {
          filter_options = {},
          position = {
            col = '50%',
            row = '50%',
          },
        },
        popup = {
          win_options = {
            winhighlight = {
              Normal = 'Normal',
              FloatBorder = 'FloatBorder',
            },
          },
        },
      },
    })
  end,
}
