 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#dce9ef',
    base01 = '#cee0e9',
    base02 = '#c7dce6',
    base03 = '#6c8897',
    base04 = '#515659',
    base05 = '#181a1b',
    base06 = '#181a1b',
    base07 = '#181a1b',
    base08 = '#fd4663',
    base09 = '#3c246d',
    base0A = '#1d2d74',
    base0B = '#165a7b',
    base0C = '#3b1b7e',
    base0D = '#175f82',
    base0E = '#1b2d7e',
    base0F = '#1f39ad',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#181a1b',          bg = '#dce9ef' })
  hi('TelescopeBorder',         { fg = '#6c8897',             bg = '#dce9ef' })
  hi('TelescopePromptNormal',   { fg = '#181a1b',          bg = '#dce9ef' })
  hi('TelescopePromptBorder',   { fg = '#6c8897',             bg = '#dce9ef' })
  hi('TelescopePromptPrefix',   { fg = '#165a7b',             bg = '#dce9ef' })
  hi('TelescopePromptCounter',  { fg = '#515659',  bg = '#dce9ef' })
  hi('TelescopePromptTitle',    { fg = '#dce9ef',             bg = '#165a7b' })
  hi('TelescopePreviewTitle',   { fg = '#dce9ef',             bg = '#1d2d74' })
  hi('TelescopeResultsTitle',   { fg = '#dce9ef',             bg = '#3c246d' })
  hi('TelescopeSelection',      { fg = '#181a1b',          bg = '#c7dce6' })
  hi('TelescopeSelectionCaret', { fg = '#165a7b',             bg = '#c7dce6' })
  hi('TelescopeMatching',       { fg = '#165a7b',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#181a1b',          bg = '#dce9ef' })
  hi('MiniPickBorder',         { fg = '#6c8897',             bg = '#dce9ef' })
  hi('MiniPickPrompt',   { fg = '#181a1b',          bg = '#dce9ef' })
  hi('MiniPickPromptPrefix',   { fg = '#165a7b',             bg = '#dce9ef' })
  hi('MiniPickBorderText',    { fg = '#dce9ef',             bg = '#165a7b' })
  hi('MiniPickMatchCurrent',      { fg = '#181a1b',          bg = '#c7dce6' })
  hi('MiniPickPromptCaret', { fg = '#165a7b',             bg = '#c7dce6' })
  hi('MiniPickMatchRanges',       { fg = '#165a7b',             bold = true })
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
