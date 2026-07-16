local gh = require('utils').gh

-- Python Basic REPL --

vim.pack.add { gh 'Vigemus/iron.nvim' }

local iron = require 'iron.core'

iron.setup {
  keymaps = {
    send_line = '++',
    visual_send = '+',
    send_motion = '+',
  },
  config = {
    -- Abre o REPL em um split horizontal na parte inferior, com altura 10
    repl_open_cmd = 'horizontal bot 10 split',

    repl_definition = {
      python = {
        command = function()
          local ipython_available = vim.fn.executable 'ipython' == 1
          local binary = ipython_available and 'ipython' or 'python3'

          return { binary }
        end,
      },
    },
  },
}
