--> Setting options
--> use `:help option-list` for more options
--> See `:h vim.o`

--> Make line numbers default
vim.o.number = true
--> Add relative line numbers
vim.o.relativenumber = true

--> Enable mouse mode (Might want to delete this after some thime)
vim.o.mouse = 'a'

--> Don't show mode, since it's already in the status line
vim.o.showmode = false

--> Sync clipboard between OS and NeoVim
--> Schedule after `UiEnter` because it can increase startup-time
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

--> Enable break indent
vim.o.breakindent = true
--> Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

--> Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

--> Keep signcolumn on by default
vim.o.signcolumn = 'yes'

--> Decrease update time
vim.o.updatetime = 250
--> Decrease mapped sequence wait time
vim.o.timeoutlen = 300

--> Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

--> Sets how neovim will display certain whitespace characters in the editor.
--> See `:help 'list'`
--> and `:help 'listchars'`
vim.o.list = true

--> `vim.opt` is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

--> Changes tabbing space
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Enables 24-bit color suport
vim.opt.termguicolors = true

--> Preview substitutions live
vim.o.inccommand = 'split'
--> Show which line your cursor is on
vim.o.cursorline = true
--> Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 999

--> If performing an operation that would fail due to unsaved changes in the buffer (like `:q`)
---> instead raise a dialog asking if you wish to save the current files(s)
----> See `:help 'confirm'`
vim.o.confirm = true
