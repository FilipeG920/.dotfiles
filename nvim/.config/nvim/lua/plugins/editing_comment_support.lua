-- ============================================================
-- EDITING AND COMMENT SUPPORT
-- ============================================================

local gh = require('utils').gh

vim.pack.add {
  gh 'danymat/neogen',
  gh 'chrisgrieser/nvim-puppeteer',
}

-- Docstring creation
require('neogen').setup {}

vim.keymap.set('n', '<leader>a', function()
  require('neogen').generate()
end, {
  desc = 'Add Docstring',
})
