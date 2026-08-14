-- C-specific configuration and keymaps

local utils = require 'custom.c-cpp-utils'

utils.set_buffer_opts()

-- Project-aware compile and run
vim.keymap.set('n', '<leader>cr', function() utils.build_and_run() end, { desc = '[C] Compile & [R]un', buffer = true })

-- Compile with debug flags
vim.keymap.set('n', '<leader>cR', function() utils.build_and_run { debug = true } end, { desc = '[C] Compile & Run (debug)', buffer = true })

-- Compile with arguments
vim.keymap.set('n', '<leader>cA', function()
    local args = vim.fn.input 'Arguments: '
    utils.build_and_run { args = args }
end, { desc = '[C] Compile & Run with [A]rgs', buffer = true })

-- Build for debugging (keeps binary)
vim.keymap.set('n', '<leader>cD', function() utils.build_for_debug() end, { desc = '[C] Build for [D]ebug', buffer = true })

-- Switch between .c and .h
vim.keymap.set('n', '<leader>ch', function() utils.switch_header() end, { desc = '[C] Switch [H]eader/Source', buffer = true })

-- Show diagnostics
vim.keymap.set('n', '<leader>ed', vim.diagnostic.open_float, { desc = 'Show diagnostics under cursor', buffer = true })

-- Compile single file (quick)
vim.keymap.set('n', '<leader>cc', function()
    local file = vim.api.nvim_buf_get_name(0)
    local dir = vim.fn.fnamemodify(file, ':h')
    local exe = vim.fn.fnamemodify(file, ':t:r')
    local cmd = string.format('cd "%s" && gcc -Wall -Wextra -O2 "%s" -o "%s" && ./%s', dir, file, exe, exe)
    vim.cmd('botright split | term ' .. cmd)
end, { desc = '[C] Compile & run', buffer = true })

-- Make commands
vim.keymap.set('n', '<leader>cm', function() utils.make_build() end, { desc = '[C] [M]ake', buffer = true })

vim.keymap.set('n', '<leader>cM', function()
    local target = vim.fn.input 'Make target: '
    utils.make_build(target)
end, { desc = '[C] Make [M]ake target', buffer = true })

-- CMake shortcuts
vim.keymap.set('n', '<leader>cC', function() utils.cmake_build { type = 'Debug' } end, { desc = '[C]Make build (Debug)', buffer = true })

vim.keymap.set('n', '<leader>cO', function() utils.cmake_build { type = 'Release' } end, { desc = '[C]Make build (Release)', buffer = true })

-- Run with sudo (for system-level programs)
vim.keymap.set('n', '<leader>cS', function()
    local file = vim.api.nvim_buf_get_name(0)
    local exe = vim.fn.fnamemodify(file, ':t:r')
    vim.cmd('botright split | term sudo ./' .. exe)
end, { desc = '[C] [S]udo run', buffer = true })

-- Generate compile_commands.json for standalone projects
vim.keymap.set('n', '<leader>cX', function()
    local file = vim.api.nvim_buf_get_name(0)
    local dir = vim.fn.fnamemodify(file, ':h')
    vim.notify('Run bear -- gcc -c ' .. file .. ' in ' .. dir, vim.log.levels.INFO)
end, { desc = '[C] Generate compile_commands hint', buffer = true })
