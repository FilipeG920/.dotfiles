-- ============================================================
-- NOTIFICATIONS
-- nvim-notify
-- ============================================================

local gh = require('utils').gh

vim.pack.add {
  gh 'rcarriga/nvim-notify',
}

local notify = require 'notify'

notify.setup {
	stages = 'fade_in_slide_out',
	timeout = 3000,
	background_colour = '#303446',
	render = 'default',
}

vim.notify = notify

vim.keymap.set('n', '<leader>un', function()
  notify.dismiss { silent = true, pending = true }
end, {
  desc = 'Dismiss notifications',
})

vim.keymap.set('n', '<leader>nh', function()
  notify.history()
end, {
  desc = 'Notification history',
})
