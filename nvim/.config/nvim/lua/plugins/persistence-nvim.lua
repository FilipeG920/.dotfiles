local gh = require('utils').gh

vim.pack.add { gh 'folke/persistence.nvim' }

vim.opt.sessionoptions = {
  'buffers',
  'curdir',
  'tabpages',
  'winsize',
  'help',
  'globals',
  'skiprtp',
  'folds',
}

require('persistence').setup {
  dir = vim.fn.stdpath 'state' .. '/sessions/',
  need = 1,
  branch = true,
}
