local gh = require('utils').gh

vim.pack.add { gh 'ellisonleao/gruvbox.nvim' }

require('gruvbox').setup()

vim.o.background = 'dark'
vim.cmd.colorscheme 'gruvbox'
