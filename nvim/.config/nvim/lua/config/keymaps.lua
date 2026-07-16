local keymap = vim.keymap.set

--> Clear highlights on search when pressing <Esc> in normal mode
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

--> Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
--> for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
--> is not what someone will guess without a bit more experience.
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", {
	desc = "Exit terminal mode",
})

--> Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

--> Keybinds to make split navigation easier
-->  Use CTRL+<hjkl> to switch between windows
--
--> See `:help wincmd` for a list of all window commands
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })


-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes

-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })


