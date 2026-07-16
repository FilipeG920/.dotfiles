local starter = require 'mini.starter'

local function command_exists(cmd) return vim.fn.exists(':' .. cmd) == 2 end

local function edit(path)
  return function() vim.cmd.edit(vim.fn.fnameescape(path)) end
end

local function open_config_dir() vim.cmd.edit(vim.fn.stdpath 'config') end

local function dev_tools()
  local items = {
    {
      name = 'Checkhealth',
      action = 'checkhealth',
      section = 'Tools',
    },
    {
      name = 'Update Plugins',
      action = function() vim.pack.update() end,
      section = 'Tools',
    },
  }

  if command_exists 'Mason' then table.insert(items, {
    name = 'Mason',
    action = 'Mason',
    section = 'Tools',
  }) end

  if command_exists 'ConformInfo' then table.insert(items, {
    name = 'ConformInfo',
    action = 'ConformInfo',
    section = 'Tools',
  }) end

  if command_exists 'LintInfo' then table.insert(items, {
    name = 'LintInfo',
    action = 'LintInfo',
    section = 'Tools',
  }) end

  return items
end

starter.setup {
  autoopen = true,
  evaluate_single = true,

  header = table.concat({
    [[                                                                       ]],
    [[                                                                     ]],
    [[       ████ ██████           █████      ██                     ]],
    [[      ███████████             █████                             ]],
    [[      █████████ ███████████████████ ███   ███████████   ]],
    [[     █████████  ███    █████████████ █████ ██████████████   ]],
    [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
    [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
    [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
    [[                                                                       ]],
  }, '\n'),

  items = {
    {
      name = 'New File',
      action = 'enew',
      section = 'Actions',
    },
    {
      name = 'Open Current Directory',
      action = 'edit .',
      section = 'Actions',
    },
    {
      name = 'Edit init.lua',
      action = edit(vim.fn.stdpath 'config' .. '/init.lua'),
      section = 'Settings',
    },
    {
      name = 'Open settings folder',
      action = open_config_dir,
      section = 'Settings',
    },
    {
      name = 'Projects',
      action = 'Project',
      section = 'Projects',
    },
    -- {
    --   name = 'Recent Projects',
    --   action = 'Projectrecents',
    --   section = 'Projects'
    -- },

    dev_tools,

    starter.sections.recent_files(4, true, false),
    starter.sections.recent_files(4, false, true),
    starter.sections.builtin_actions(),
  },

  content_hooks = {
    starter.gen_hook.adding_bullet '» ',
    starter.gen_hook.indexing('all', {
      'Builtin actions',
    }),
    starter.gen_hook.padding(3, 2),
    starter.gen_hook.aligning('center', 'center'),
  },

  footer = function()
    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
    return 'Current Directory: ' .. cwd
  end,
}

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniStarterOpened',
  callback = function() vim.b.ministatusline_disable = true end,
})
