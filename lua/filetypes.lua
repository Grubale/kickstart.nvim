-- @module filetypes

local function tsconfig_callback()
  vim.bo.commentstring = '#%s'
  vim.bo.syntax = 'tsconfig'
  vim.o.foldmethod = 'syntax'
  return 'tsconfig'
end

local function typoscript_callback()
  vim.bo.commentstring = '#%s'
  vim.bo.syntax = 'typoscript'
  vim.o.foldmethod = 'syntax'
  return 'typoscript'
end

vim.filetype.add({
  extension = {
    tsconfig = tsconfig_callback,
    typoscript = typoscript_callback,
  },
  pattern = {
    ['.*/TypoScript/.*%.ts'] = {
      priority = math.huge,
      typoscript_callback,
    },
    ['.*/TypoScript/.*%.txt'] = {
      priority = math.huge,
      typoscript_callback,
    },
  },
})
