local gh = require('utils').gh

vim.pack.add { gh 'nvim-flutter/flutter-tools.nvim' }

require('flutter-tools').setup {}
