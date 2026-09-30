 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#23201a',
    base01 = '#3a362c',
    base02 = '#353027',
    base03 = '#6f6a5f',
    base04 = '#b6b4af',
    base05 = '#f3f2f2',
    base06 = '#f3f2f2',
    base07 = '#f3f2f2',
    base08 = '#fd4663',
    base09 = '#91ad85',
    base0A = '#a9b181',
    base0B = '#c1b08b',
    base0C = '#b9d0af',
    base0D = '#d3c6ac',
    base0E = '#cad0af',
    base0F = '#e0e4cd',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#f3f2f2',          bg = '#23201a' })
  hi('TelescopeBorder',         { fg = '#6f6a5f',             bg = '#23201a' })
  hi('TelescopePromptNormal',   { fg = '#f3f2f2',          bg = '#23201a' })
  hi('TelescopePromptBorder',   { fg = '#6f6a5f',             bg = '#23201a' })
  hi('TelescopePromptPrefix',   { fg = '#c1b08b',             bg = '#23201a' })
  hi('TelescopePromptCounter',  { fg = '#b6b4af',  bg = '#23201a' })
  hi('TelescopePromptTitle',    { fg = '#23201a',             bg = '#c1b08b' })
  hi('TelescopePreviewTitle',   { fg = '#23201a',             bg = '#a9b181' })
  hi('TelescopeResultsTitle',   { fg = '#23201a',             bg = '#91ad85' })
  hi('TelescopeSelection',      { fg = '#f3f2f2',          bg = '#353027' })
  hi('TelescopeSelectionCaret', { fg = '#c1b08b',             bg = '#353027' })
  hi('TelescopeMatching',       { fg = '#c1b08b',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#f3f2f2',          bg = '#23201a' })
  hi('MiniPickBorder',         { fg = '#6f6a5f',             bg = '#23201a' })
  hi('MiniPickPrompt',   { fg = '#f3f2f2',          bg = '#23201a' })
  hi('MiniPickPromptPrefix',   { fg = '#c1b08b',             bg = '#23201a' })
  hi('MiniPickBorderText',    { fg = '#23201a',             bg = '#c1b08b' })
  hi('MiniPickMatchCurrent',      { fg = '#f3f2f2',          bg = '#353027' })
  hi('MiniPickPromptCaret', { fg = '#c1b08b',             bg = '#353027' })
  hi('MiniPickMatchRanges',       { fg = '#c1b08b',             bold = true })
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
