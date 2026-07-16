require 'config.globals'
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.diagnostics'
require 'config.pack'

require 'plugins.ui'
require 'plugins.colorscheme'
require 'plugins.mini'
require 'plugins.dashboard-nvim'
require 'plugins.telescope'
require 'plugins.lsp'
require 'plugins.conform'
require 'plugins.completion'
require 'plugins.treesitter'
require 'plugins.oil'
require 'plugins.neotree'
require 'plugins.lint'
require 'plugins.debug'
require 'plugins.editing_comment_support'
require 'plugins.nvim-notify'
require 'plugins.project'
require 'plugins.nvim-ts-autotag' -- Cool shit I think...
require 'plugins.obsidian'

vim.g.live_server = {
  port = 8080,
  browser = false,
}
require 'plugins.live-server'

require 'plugins.python'
require 'plugins.flutter-tools'
require 'plugins.typescript-tools'
require 'plugins.rust'
require 'plugins.textual-css'

-- require 'custom.plugins' --> Directory for plugins made by me

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
