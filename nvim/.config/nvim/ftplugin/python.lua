-- PEP 8 indentation
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

-- Folds based on indentation
vim.opt_local.foldmethod = 'indent'

local iabbrev = function(lhs, rhs) vim.keymap.set('ia', lhs, rhs, { buffer = true }) end

iabbrev('true', 'True')
iabbrev('false', 'False')
iabbrev('--', '#')
iabbrev('null', 'None')
iabbrev('none', 'None')
iabbrev('nil', 'None')
iabbrev('function', 'def')

-- REPL keymaps
vim.keymap.set('n', '<leader>i', vim.cmd.IronRepl, {
  desc = 'Python: 󱠤 Toggle REPL',
})

vim.keymap.set('n', '<leader>I', vim.cmd.IronRestart, {
  desc = 'Python: 󱠤 Restart REPL',
})
