local gh = require('utils').gh

vim.pack.add { gh 'nvimdev/dashboard-nvim' }

local uv = vim.uv or vim.loop

local function command_exists(cmd) return vim.fn.exists(':' .. cmd) == 2 end

local function escaped(path) return vim.fn.fnameescape(path) end

local function action_edit(path) return 'edit ' .. escaped(path) end

local center = {}

local function add(section, icon, desc, key, action)
  table.insert(center, {
    icon = icon,
    icon_hl = 'DashboardIcon',
    desc = string.format('%-9s %s', section, desc),
    desc_hl = 'DashboardDesc',
    key = key,
    key_hl = 'DashboardKey',
    key_format = ' %s',
    action = action,
  })
end

local config_dir = vim.fn.stdpath 'config'

-- Actions
add('Actions', ' ', 'New File', 'n', 'enew')
add('Actions', ' ', 'Open Current Directory', 'o', 'edit .')

-- Settings
add('Settings', ' ', 'Edit init.lua', 'i', action_edit(config_dir .. '/init.lua'))
add('Settings', ' ', 'Open Config Folder', 'c', action_edit(config_dir))

-- Projects
if command_exists 'Project' then
  add('Projects', '󱎸 ', 'Projects', 'p', 'Project')
  add('Projects', '󰋚 ', 'Recent Projects', 'r', 'Project recents')
  -- Optional: project.nvim session picker
  -- Requires fd installed
  add('Projects', '󱂬 ', 'Project Sessions', 'P', 'Project session')
end

-- Sessions
if pcall(require, 'persistence') then
  add('Sessions', ' ', 'Restore Session', 's', 'lua require("persistence").load()')
  add('Sessions', '󰁯 ', 'Last Session', 'S', 'lua require("persistence").load({ last = true })')
  add('Sessions', '󰭎 ', 'Select Session', 'q', 'lua require("persistence").select()')
end

-- Tools
add('Tools', '󰒓 ', 'Checkhealth', 'h', 'checkhealth')
add('Tools', '󰚰 ', 'Update Plugins', 'u', 'lua vim.pack.update()')

if command_exists 'Mason' then add('Tools', '󰏖 ', 'Mason', 'm', 'Mason') end

if command_exists 'ConformInfo' then add('Tools', '󰉢 ', 'ConformInfo', 'f', 'ConformInfo') end

if command_exists 'LintInfo' then add('Tools', '󰁨 ', 'LintInfo', 'l', 'LintInfo') end

local function add_recent_files(limit, cwd_only, start_key)
  local cwd = vim.fn.fnamemodify(uv.cwd() or vim.fn.getcwd(), ':p')
  local cwd_prefix = cwd:gsub('/$', '') .. '/'
  local seen = {}
  local count = 0

  for _, file in ipairs(vim.v.oldfiles) do
    file = vim.fn.fnamemodify(file, ':p')

    local readable = vim.fn.filereadable(file) == 1
    local inside_cwd = file:sub(1, #cwd_prefix) == cwd_prefix

    if readable and not seen[file] and (not cwd_only or inside_cwd) then
      seen[file] = true
      count = count + 1

      local name = cwd_only and vim.fn.fnamemodify(file, ':.') or vim.fn.fnamemodify(file, ':~')

      add(cwd_only and 'Recent' or 'Global', '󰈙 ', name, tostring(start_key + count - 1), action_edit(file))

      if count >= limit then break end
    end
  end
end

-- Keep this small to avoid a bloated dashboard
add_recent_files(2, true, 1)
add_recent_files(2, false, 3)

require('dashboard').setup {
  theme = 'doom',

  hide = {
    statusline = true,
    tabline = true,
    winbar = true,
  },

  config = {
    header = {
      '███████╗██████╗ ███████╗███╗   ██╗',
      '██╔════╝██╔══██╗██╔════╝████╗  ██║',
      '█████╗  ██║  ██║█████╗  ██╔██╗ ██║',
      '██╔══╝  ██║  ██║██╔══╝  ██║╚██╗██║',
      '███████╗██████╔╝███████╗██║ ╚████║',
      '╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═══╝',
      '                                  ',
    },

    center = center,

    footer = {
      '',
      'cwd: ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':~'),
    },

    vertical_center = true,
  },
}
