-- Java test runner via neotest + nvim-jdtls
return {
    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-neotest/nvim-nio',
            'nvim-treesitter/nvim-treesitter',
            'antoinemadec/FixCursorHold.nvim',
        },
        ft = 'java',
        config = function()
            local neotest = require 'neotest'
            local adapters = {}

            -- Load neotest-jdtls if available
            local ok, adapter = pcall(require, 'neotest-jdtls')
            if ok then adapters[#adapters + 1] = adapter end

            neotest.setup {
                adapters = adapters,
                output = { open_on_run = true },
                summary = { mappings = { run = '<CR>', expand = 'o' } },
            }
        end,
        keys = {
            { '<leader>t', function() require('neotest').run.run() end, desc = 'Run nearest test' },
            { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Run test file' },
            { '<leader>td', function() require('neotest').run.run(vim.fn.getcwd()) end, desc = 'Run test directory' },
            { '<leader>tp', function() require('neotest').output_panel.toggle() end, desc = 'Toggle test output panel' },
            { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Run last test' },
            { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Toggle test summary' },
            { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand '%') end, desc = 'Watch test file' },
            { '<leader>to', function() require('neotest').output_panel.toggle() end, desc = 'Toggle test output' },
        },
    },
    -- The neotest-jdtls adapter plugin
    {
        'atm1020/neotest-jdtls',
        ft = 'java',
        dependencies = {
            'nvim-neotest/neotest',
            'mfussenegger/nvim-jdtls',
        },
    },
}
