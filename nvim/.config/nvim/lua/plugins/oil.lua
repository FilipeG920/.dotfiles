local gh = require('utils').gh

vim.pack.add({ gh 'stevearc/oil.nvim' } )

require('oil').setup {
  view_options = {
    show_hidden = false,
  },
}

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
