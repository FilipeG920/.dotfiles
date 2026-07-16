-- autopairs
-- https://github.com/windwp/nvim-autopairs

vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }
require('nvim-autopairs').setup()
-- local npairs = require 'nvim-autopairs'

-- Not working for some reason
-- fastwrap
-- npairs.setup {
--   fast_wrap = {
--     map = '<M-e>',
--     chars = { '{', '[', '(', '"', "'" },
--     pattern = [=[[%'%"%>%]%)%}%,]]=],
--     end_key = '$',
--     before_key = 'h',
--     after_key = 'l',
--     cursor_pos_before = true,
--     keys = 'qwertyuiopzxcvbnmasdfghjkl',
--     manual_position = true,
--     highlight = 'Search',
--     highlight_grey = 'Comment',
--   },
-- }
