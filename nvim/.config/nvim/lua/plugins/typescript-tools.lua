local gh = require('utils').gh

vim.pack.add { gh 'pmizio/typescript-tools.nvim' }

require('typescript-tools').setup {
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  jsx_close_tag = {
    enable = false,
    filetypes = { 'javascriptreact', 'typescriptreact' },
  },
}
