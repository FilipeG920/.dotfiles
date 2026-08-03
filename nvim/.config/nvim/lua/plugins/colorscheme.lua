local gh = require('utils').gh

vim.pack.add { gh 'ellisonleao/gruvbox.nvim' }

require('gruvbox').setup {
  overrides = {
    BufferLineFill                = { bg = '#1d2021' },                    -- bar background
    BufferLineBackground          = { fg = '#928374', bg = '#3c3836' },    -- inactive tabs
    BufferLineBufferVisible       = { fg = '#a89984', bg = '#3c3836' },
    BufferLineBufferSelected      = { fg = '#fbf1c7', bg = '#282828', bold = true, italic = false },
    -- for slope separators, separator fg must match the fill bg so it blends
    BufferLineSeparator           = { fg = '#1d2021', bg = '#3c3836' },
    BufferLineSeparatorVisible    = { fg = '#1d2021', bg = '#3c3836' },
    BufferLineSeparatorSelected   = { fg = '#1d2021', bg = '#282828' },
    BufferLineModified            = { fg = '#fabd2f', bg = '#3c3836' },
    BufferLineModifiedSelected    = { fg = '#fabd2f', bg = '#282828' },
    BufferLineIndicatorSelected   = { fg = '#fabd2f', bg = '#282828' },
    BufferLineCloseButton         = { fg = '#928374', bg = '#3c3836' },
    BufferLineCloseButtonSelected = { fg = '#fb4934', bg = '#282828' },
  },
}

vim.o.background = 'dark'
vim.cmd.colorscheme 'gruvbox'
