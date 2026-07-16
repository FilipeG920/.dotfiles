local gh = require('utils').gh

vim.pack.add { gh 'cachebag/nvim-tcss' }

require('tcss').setup {
  -- Enable syntax highlighting (default: true)
  enable = true,

  -- Custom color overrides
  -- colors = {
  --     -- Add custom highlighting rules here
  -- }
}
