local gh = require('utils').gh

vim.pack.add { gh 'kosayoda/nvim-lightbulb' }

require('nvim-lightbulb').setup {
  autocmd = { enabled = true },
}
