-- C++-specific configuration and keymaps

local utils = require 'custom.c-cpp-utils'

utils.set_buffer_opts()

-- Override for C++ defaults
vim.opt_local.commentstring = '// %s'

-- Project-aware compile and run
vim.keymap.set('n', '<leader>cr', function()
  utils.build_and_run()
end, { desc = '[C++] Compile & Run', buffer = true })

-- Build current file only (no run)
vim.keymap.set('n', '<leader>cF', function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then vim.notify('No file', vim.log.levels.ERROR) return end
  local dir = vim.fn.fnamemodify(file, ':h')
  local exe = vim.fn.fnamemodify(file, ':t:r')
  vim.cmd 'botright 10new'
  local win = vim.api.nvim_get_current_win()
  local build_cmd = string.format(
    [[cd "%s" && output=$(g++ -std=c++20 -Wall -Wextra -O2 "%s" -o "%s" 2>&1); ret=$?; echo "$output"; if [ $ret -ne 0 ]; then exit 1; elif echo "$output" | grep -q "warning:"; then echo "Build OK with warnings"; exit 1; else echo "Build OK: ./%s"; exit 0; fi]],
    dir, file, exe, exe
  )
  vim.fn.termopen({ 'bash', '-c', build_cmd }, {
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 and vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })
end, { desc = '[C++] Build current [F]ile', buffer = true })

-- Compile with arguments
vim.keymap.set('n', '<leader>cA', function()
  local args = vim.fn.input 'Arguments: '
  utils.build_and_run { args = args }
end, { desc = '[C++] Compile & Run with [A]rgs', buffer = true })

-- Build for debugging
vim.keymap.set('n', '<leader>cD', function()
  utils.build_for_debug()
end, { desc = '[C++] Build for [D]ebug', buffer = true })

-- Switch between .cpp and .hpp/.h
vim.keymap.set('n', '<leader>ch', function()
  utils.switch_header()
end, { desc = '[C++] Switch [H]eader/Source', buffer = true })

-- Show diagnostics
vim.keymap.set('n', '<leader>ed', vim.diagnostic.open_float, { desc = 'Show diagnostics under cursor', buffer = true })

-- Quick compile with C++20
vim.keymap.set('n', '<leader>cc', function()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(file, ':h')
  local exe = vim.fn.fnamemodify(file, ':t:r')
  local cmd = string.format('cd "%s" && g++ -std=c++20 -Wall -Wextra -O2 "%s" -o "%s" && ./%s', dir, file, exe, exe)
  vim.cmd('botright split | term ' .. cmd)
end, { desc = '[C++] Compile & run (C++20)', buffer = true })

-- C++23 compile
vim.keymap.set('n', '<leader>cP', function()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(file, ':h')
  local exe = vim.fn.fnamemodify(file, ':t:r')
  local cmd = string.format('cd "%s" && g++ -std=c++23 -Wall -Wextra -O2 "%s" -o "%s" && ./%s', dir, file, exe, exe)
  vim.cmd('botright split | term ' .. cmd)
end, { desc = '[C++] Compile & run (C++23)', buffer = true })

-- Debug compile (with -g)
vim.keymap.set('n', '<leader>cG', function()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(file, ':h')
  local exe = vim.fn.fnamemodify(file, ':t:r')
  local cmd = string.format('cd "%s" && g++ -std=c++20 -g -Wall -Wextra "%s" -o "%s" && echo "OK: ./%s"', dir, file, exe, exe)
  vim.cmd('botright split | term ' .. cmd)
end, { desc = '[C++] Compile with debug symbols', buffer = true })

-- Make commands
vim.keymap.set('n', '<leader>cm', function()
  utils.make_build()
end, { desc = '[C++] [M]ake', buffer = true })

vim.keymap.set('n', '<leader>cM', function()
  local target = vim.fn.input 'Make target: '
  utils.make_build(target)
end, { desc = '[C++] Make target', buffer = true })

-- CMake shortcuts
vim.keymap.set('n', '<leader>cC', function()
  utils.cmake_build { type = 'Debug' }
end, { desc = '[C++] CMake build (Debug)', buffer = true })

vim.keymap.set('n', '<leader>cO', function()
  utils.cmake_build { type = 'Release' }
end, { desc = '[C++] CMake build (Release)', buffer = true })

-- Run with sudo
vim.keymap.set('n', '<leader>cS', function()
  local file = vim.api.nvim_buf_get_name(0)
  local exe = vim.fn.fnamemodify(file, ':t:r')
  vim.cmd('botright split | term sudo ./' .. exe)
end, { desc = '[C++] [S]udo run', buffer = true })

-- Competitive programming: set up for CP mode
vim.keymap.set('n', '<leader>cX', function()
  vim.opt_local.tabstop = 2
  vim.opt_local.shiftwidth = 2
  vim.opt_local.softtabstop = 2
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
  vim.notify('CP mode enabled: 2-space indent, wrap on', vim.log.levels.INFO)
end, { desc = '[C++] Toggle CP mode', buffer = true })
