local gh = require('utils').gh

vim.pack.add { gh 'windwp/nvim-ts-autotag' }

require('nvim-ts-autotag').setup {}
