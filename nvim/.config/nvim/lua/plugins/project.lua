-- ============================================================
-- PROJECT MANAGEMENT
-- project.nvim
-- ============================================================

local gh = require('utils').gh

vim.pack.add {
	gh 'DrKJeff16/project.nvim',
}

require('project').setup {
  -- Detects the project root by searching for standard files/folders
  detection_methods = { 'pattern' },

  -- Change the Neovim global directory to the project root
  scope_chdir = 'global',

  -- Files/folders used to identify the project root
  patterns = {
    '.git',
    '_darcs',
    '.hg',
    '.bzr',
    '.svn',

    -- Python
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',

    -- Javascript / TypeScript / Node
    'package.json',
    'tsconfig.json',

    -- C/C++
    'Makefile',
    'CMakeLists.txt',
    'compile_commands.json',

    -- Go / Rust
    'go.mod',
    'Cargo.toml',

    -- Java
    'pom.xml',
    'build.gradle',
    'settings.gradle',

    -- Flutter / Dart
    'pubspec.yaml',

    -- Lua / Neovim
    '.luarc.json',
    '.luarc.jsonc',
    'stylua.toml',
  },

  -- Avoid detecting projects within useless locations
  exclude_dirs = {
    '~/.local/share/nvim/*',
    '~/.cache/*',
    '/tmp/*',
  },

  -- Does not change the current working directory for these file types
  exclude_ft = {
    'help',
    'alpha',
    'dashboard',
    'neo-tree',
    'NvimTree',
    'TelescopePrompt',
    'mason',
    'lazy',
  },

  -- The current working directory does not change for these buffer types
  exclude_bt = {
    'terminal',
    'nofile',
    'quickfix',
    'prompt',
  },

  -- Neo-tree integration
  integrations = {
    neo_tree = true,
  },
}

vim.keymap.set('n', '<leader>fp', '<cmd>ProjectRecents<CR>', {
  desc = 'Find recent projects',
})

vim.keymap.set('n', '<leader>pr', '<cmd>ProjectRoot<CR>', {
  desc = 'Set cwd to project root',
})

vim.keymap.set('n', '<leader>ph', '<cmd>ProjectHistory<CR>', {
  desc = 'Project history',
})
