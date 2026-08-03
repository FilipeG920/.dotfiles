local gh = require('utils').gh

vim.pack.add { gh 'akinsho/bufferline.nvim' }
local bufferline = require 'bufferline'
bufferline.setup {
  options = {
    themable = true,
    separator_style = 'slope',
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>bp', '<cmd>BufferLinePick<CR>', { desc = 'Pick a buffer' })
