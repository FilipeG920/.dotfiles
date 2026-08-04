-- lua/plugins/colorscheme.lua
-- xeno.nvim driven by iris — replaces the gruvbox setup.
-- Reads ~/.cache/iris/colors.json directly (no template/symlink needed),
-- feeds iris's colors to xeno as seeds, and live-reloads when iris runs.local gh = require('utils').gh

local gh = require('utils').gh

vim.pack.add { gh 'kyzabuilds/xeno.nvim' }

local xeno = require 'xeno'
local uv = vim.uv or vim.loop

local iris_path = vim.fn.expand '~/.cache/iris/colors.json'

local function read_iris()
  local f = io.open(iris_path, 'r')
  if not f then return nil end
  local raw = f:read '*a'
  f:close()
  local ok, data = pcall(vim.json.decode, raw)
  if not ok or type(data) ~= 'table' or type(data.bg) ~= 'string' then return nil end
  return data
end

local function apply()
  local iris = read_iris()
  if not iris then
    vim.notify('iris colors not found — run `iris <wallpaper>` once', vim.log.levels.WARN)
    return
  end

  -- colors.json carries iris's real dark/light decision (boolean)
  vim.o.background = (iris.dark == false) and 'light' or 'dark'

  -- iris's hue-rotated syntax colors become xeno families (full OKLCH scales).
  -- xeno.color() must be called BEFORE xeno.setup()/theme() uses them.
  xeno
    .color('kw', iris.syntax_keyword)
    .color('str', iris.syntax_string)
    .color('fn', iris.syntax_func)
    .color('ty', iris.syntax_type)
    .color('cst', iris.syntax_const)
    .color('prm', iris.syntax_param)
    .color('op', iris.syntax_operator)

  xeno.setup {
    background = iris.bg,
    foreground = iris.fg,
    accent = iris.accent,
    red = iris.red,
    green = iris.green,
    yellow = iris.yellow,
    transparent = true,

    -- knobs reshape the whole palette (guide §2). muted/shadcn-ish feel:
    properties = { contrast = -0.05, chroma = 0.05 },
    min_contrast = 4.5, -- WCAG AA floor for text (guide §accessibility)

    -- CRITICAL: ghostty integration defaults to ON and writes ghostty config.
    integrations = { ghostty = { enabled = false } },

    highlights = {
      editor = {}, -- xeno defaults are tuned; leave empty (guide §3d)
      syntax = {
        Comment = { fg = '@foreground.400', italic = true },

        -- everyday bulk of syntax at .200/.300 (guide §2/§3c)
        ['@keyword'] = { fg = '@kw.300' },
        ['@keyword.function'] = { link = '@keyword' },
        ['@keyword.return'] = { fg = '@kw.200' },
        ['@keyword.conditional'] = { link = '@keyword' },
        ['@keyword.repeat'] = { link = '@keyword' },
        ['@keyword.import'] = { fg = '@kw.400' },

        ['@function'] = { fg = '@fn.300' },
        ['@function.builtin'] = { fg = '@fn.200' },
        ['@type'] = { fg = '@ty.300' },

        ['@variable'] = { fg = '@foreground.300' }, -- keep quiet (§3c)
        ['@variable.builtin'] = { fg = '@prm.300' },
        ['@property'] = { fg = '@foreground.200' },
        ['@operator'] = { fg = '@op.400' },
        ['@punctuation'] = { fg = '@foreground.400' },

        -- literals lead the eye at .100 (guide §2 "emphasis lever")
        ['@string'] = { fg = '@str.200' },
        ['@string.escape'] = { fg = '@str.100' },
        ['@number'] = { fg = '@cst.100' },
        ['@boolean'] = { fg = '@cst.100' },
        ['@constant'] = { fg = '@cst.200' },
        ['@constant.builtin'] = { fg = '@cst.100', bold = true },

        -- no pop-in: LSP semantic layers agree with treesitter (guide §3b)
        ['@lsp.type.variable'] = { link = '@variable' },
        ['@lsp.type.property'] = { link = '@property' },
        ['@lsp.mod.declaration'] = { clear = true },

        -- legacy groups as link fallbacks for non-treesitter buffers
        Type = { link = '@type' },
        Function = { link = '@function' },
        String = { link = '@string' },
      },
    },
  }
end

apply()

-- ---- live reload ----------------------------------------------------------
-- iris rewrites colors.json on every run (incl. setwall.sh); re-apply in
-- every open nvim instance. Same watcher pattern as the Alphonso config.
local function start_watcher()
  local w = uv.new_fs_event()
  w:start(iris_path, {}, function()
    w:stop()
    vim.schedule(function()
      apply()
      vim.defer_fn(apply, 150) -- iris may write in two passes; settle first
      start_watcher()
    end)
  end)
end
start_watcher()

-- Tuning notes:

--     The overall mood lives in properties = { contrast = -0.05, chroma = 0.05 } — I preset a slightly muted look to match your shadcn bar/rofi. Push chroma up for more vivid, drop contrast to -0.2 for pastel softness.
--     I set min_contrast = 4.5 (WCAG AA floor). If you find xeno fights iris's colors on light wallpapers, this is why — remove it for pure iris colors.
--     If you want the terminal background to show through instead of nvim's @background.950, add transparent = true to the setup table — with iris's terminal sequences theming your terminal, that makes the whole screen one continuous palette.
--     The syntax spec follows the guide's rules: bulk tokens at .200/.300, strings/numbers/constants at .100 for emphasis, comments/punctuation receded to .400, and @lsp.type.* linked to their treesitter equivalents so you don't get color pop-in when an LSP attaches.

-- Caveats: repeated xeno.setup() calls on reload may accumulate some internal autocmds over a very long session — harmless in practice, but if you notice lag after many wallpaper switches, restarting nvim resets it. And your old gruvbox bufferline overrides are gone with gruvbox — bufferline was commented out in your init.lua anyway, so nothing visible changes there.
