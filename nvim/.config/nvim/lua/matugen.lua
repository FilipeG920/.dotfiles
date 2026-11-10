 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#002b36',
    base01 = '#06313c',
    base02 = '#08404f',
    base03 = '#31788d',
    base04 = '#657b83',
    base05 = '#839496',
    base06 = '#839496',
    base07 = '#839496',
    base08 = '#dc322f',
    base09 = '#cb4b16',
    base0A = '#d33682',
    base0B = '#b58900',
    base0C = '#f3aa8c',
    base0D = '#ffe080',
    base0E = '#e996be',
    base0F = '#f4bed8',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#839496',          bg = '#002b36' })
  hi('TelescopeBorder',         { fg = '#31788d',             bg = '#002b36' })
  hi('TelescopePromptNormal',   { fg = '#839496',          bg = '#002b36' })
  hi('TelescopePromptBorder',   { fg = '#31788d',             bg = '#002b36' })
  hi('TelescopePromptPrefix',   { fg = '#b58900',             bg = '#002b36' })
  hi('TelescopePromptCounter',  { fg = '#657b83',  bg = '#002b36' })
  hi('TelescopePromptTitle',    { fg = '#002b36',             bg = '#b58900' })
  hi('TelescopePreviewTitle',   { fg = '#002b36',             bg = '#d33682' })
  hi('TelescopeResultsTitle',   { fg = '#002b36',             bg = '#cb4b16' })
  hi('TelescopeSelection',      { fg = '#839496',          bg = '#08404f' })
  hi('TelescopeSelectionCaret', { fg = '#b58900',             bg = '#08404f' })
  hi('TelescopeMatching',       { fg = '#b58900',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#839496',          bg = '#002b36' })
  hi('MiniPickBorder',         { fg = '#31788d',             bg = '#002b36' })
  hi('MiniPickPrompt',   { fg = '#839496',          bg = '#002b36' })
  hi('MiniPickPromptPrefix',   { fg = '#b58900',             bg = '#002b36' })
  hi('MiniPickBorderText',    { fg = '#002b36',             bg = '#b58900' })
  hi('MiniPickMatchCurrent',      { fg = '#839496',          bg = '#08404f' })
  hi('MiniPickPromptCaret', { fg = '#b58900',             bg = '#08404f' })
  hi('MiniPickMatchRanges',       { fg = '#b58900',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
