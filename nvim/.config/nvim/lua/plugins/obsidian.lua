local gh = require('utils').gh

vim.pack.add { { src = gh 'obsidian-nvim/obsidian.nvim', version = vim.version.range '*' } }

require('obsidian').setup {
  legacy_commands = false,
  picker = {
    name = 'telescope.nvim',
  },
  workspaces = {
    {
      name = 'Neo-Eden',
      path = '~/Documentos/Neo-Eden/',
    },
  },
  callbacks = {
    enter_note = function(note)
      local actions = require 'obsidian.actions'
      -- Smart actions
      vim.keymap.set('n', '<leader>;', actions.add_property, { buffer = true, desc = 'Obsidian: Add frontmatter property' })
      vim.keymap.set('n', '<leader>och', '<cmd>Obsidian toggle_checkbox<cr>', { buffer = true, desc = 'Obsidian: Toggle checkbox' })
      vim.keymap.set('n', '<leader>ofl', '<cmd>Obsidian follow_link<cr>', { buffer = true, desc = 'Obsidian: Follow link' })
      vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian tags<cr>', { buffer = true, desc = 'Obsidian: View all tagged notes' })
      vim.keymap.set('n', '<leader>ohf', 'za', { buffer = true, desc = 'Obsidian: Cycle the fold of heading' })

      -- Link navigation
      vim.keymap.set('n', ']o', function() actions.nav_link 'next' end, { buffer = true, desc = 'Obsidian: Go to next link' })
      vim.keymap.set('n', '[o', function() actions.nav_link 'prev' end, { buffer = true, desc = 'Obsidian: Go to previous link' })

      -- Visual mode actions
      vim.keymap.set('x', '<leader>ol', function() actions.link() end, { buffer = true, desc = 'Obsidian: Link selection to existing note' })
      vim.keymap.set('x', '<leader>onl', function() actions.link_new() end, { buffer = true, desc = 'Obsidian: Create note from visual selection' })
      vim.keymap.set('x', '<leader>oet', function() actions.extract_note() end, { buffer = true, desc = 'Obsidian: Extract text into new note' })

      -- Note creation
      vim.keymap.set('n', '<leader>ont', function() actions.new_from_template() end, { buffer = true, desc = 'Obsidian: New note from template' })
    end,
  },
}
