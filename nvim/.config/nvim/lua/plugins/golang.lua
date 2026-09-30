local gh = require('utils').gh

vim.pack.add { gh 'ray-x/go.nvim' }

require('go').setup {
  lsp_keymaps = false,
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function(event)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, {
        buffer = event.buf,
        silent = true,
        desc = 'Go: ' .. desc,
      })
    end

    -- Run / Build
    map('<leader>Gr', '<cmd>GoRun<cr>', 'Run')
    map('<leader>Gb', '<cmd>GoBuild<cr>', 'Build')

    -- Tests
    map('<leader>Gtt', '<cmd>GoTestFunc<cr>', 'Test function')
    map('<leader>Gtf', '<cmd>GoTestFile<cr>', 'Test file')
    map('<leader>Gtp', '<cmd>GoTestPkg<cr>', 'Test package')
    map('<leader>Gta', '<cmd>GoTest<cr>', 'Test all')
    map('<leader>Gtc', '<cmd>GoCoverage -p<cr>', 'Test coverage')

    -- Alternate source/test files
    map('<leader>Ga', '<cmd>GoAlt<cr>', 'Alternate file')
    map('<leader>Gav', '<cmd>GoAltV<cr>', 'Alternate file vertical')
    map('<leader>Gas', '<cmd>GoAltS<cr>', 'Alternate file split')

    -- Code generation
    map('<leader>Ge', '<cmd>GoIfErr<cr>', 'Add if err')
    map('<leader>Gf', '<cmd>GoFillStruct<cr>', 'Fill struct')
    map('<leader>Gs', '<cmd>GoFillSwitch<cr>', 'Fill switch')

    -- `GoImpl` needs an interface argument, so leave the command line open
    map('<leader>Gi', ':GoImpl ', 'Implement interface')

    -- Documentation
    map('<leader>Gd', '<cmd>GoDoc<cr>', 'Documentation')
    map('<leader>Gc', '<cmd>GoCmt<cr>', 'Generate comment')

    -- Tooling
    map('<leader>Gl', '<cmd>GoLint<cr>', 'Lint')
    map('<leader>Gm', '<cmd>GoModTidy<cr>', 'Mod tidy')

    -- Debugging
    map('<leader>Gdd', '<cmd>GoDebug<cr>', 'Debug')
    map('<leader>Gdt', '<cmd>GoDebug -n<cr>', 'Debug nearest test')
    map('<leader>Gdb', '<cmd>GoBreakToggle<cr>', 'Toggle breakpoint')
  end,
})
