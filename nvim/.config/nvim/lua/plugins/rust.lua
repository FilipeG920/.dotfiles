local gh = require('utils').gh

vim.pack.add {
  {
    src = gh 'mrcjkb/rustaceanvim',
    version = vim.version.range '^9',
  },
  {
    src = gh 'Saecki/crates.nvim',
    version = vim.version.range '0.7.*',
  },
}
