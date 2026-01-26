-- C-specific configuration and keymaps

local opts = { buffer = true, noremap = true, silent = true }

-- Compile and run current C file
vim.keymap.set('n', '<leader>cc', function()
  local file = vim.api.nvim_buf_get_name(0)
  local executable = vim.fn.fnamemodify(file, ':t:r')
  local dir = vim.fn.fnamemodify(file, ':h')
  local cmd = string.format('cd "%s" && gcc -Wall -Wextra "%s" -o "%s" && ./%s; rm -f "%s"', dir, file, executable, executable, executable)
  vim.cmd('botright split | term ' .. cmd)
end, { desc = 'Compile and run current C file', buffer = true })

-- Show diagnostics in a floating window when cursor is on a squiggly line
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics under cursor', buffer = true })
