-- Global keymaps (buffer-local keymaps live in ftplugin/*.lua)

-- Clear search highlights with <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keep cursor centered when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z')

-- Make Y behave like C and D (yank to end of line)
vim.keymap.set('n', 'Y', 'y$')

-- Disable Ex mode
vim.keymap.set('n', 'Q', '<nop>')

-- Paste without overwriting register
vim.keymap.set('v', 'p', '"_dP')

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move visual block
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move block down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move block up' })

-- Jump to beginning/end of line
vim.keymap.set({ 'n', 'o', 'x' }, '<S-h>', '^', { desc = 'Jump to beginning of line' })
vim.keymap.set({ 'n', 'o', 'x' }, '<S-l>', 'g_', { desc = 'Jump to end of line' })

-- Select all
vim.keymap.set('n', '==', 'gg<S-v>G', { desc = 'Select all' })

-- Search for highlighted text in visual mode
vim.keymap.set('v', '//', 'y/<C-R>"<CR>', { desc = 'Search for highlighted text' })

-- Quickfix navigation
vim.keymap.set('n', '<leader>;;', '<cmd>cprev<CR>zz', { desc = 'Previous quickfix' })
vim.keymap.set('n', '<leader>]]', '<cmd>cnext<CR>zz', { desc = 'Next quickfix' })

-- Resize splits with arrows
vim.keymap.set('n', '<C-S-Down>', ':resize +2<CR>', { desc = 'Resize horizontal split down' })
vim.keymap.set('n', '<C-S-Up>', ':resize -2<CR>', { desc = 'Resize horizontal split up' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Resize vertical split left' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Resize vertical split right' })

-- Toggle word wrap
vim.keymap.set('n', '<leader>uw', function() vim.wo.wrap = not vim.wo.wrap end, { desc = 'Toggle [W]ord wrap' })

-- Copy full file path to clipboard
vim.keymap.set('n', '<leader>fp', function()
    local path = vim.fn.expand '%:p'
    vim.fn.system('wl-copy', path)
end, { desc = 'Copy full [F]ile [P]ath to clipboard' })

-- Open nvim config
vim.keymap.set('n', '<leader>vn', '<cmd>e $MYVIMRC<CR>', { desc = 'Open init.lua' })
vim.keymap.set('n', '<leader>vc', function() vim.cmd('e ' .. vim.fn.stdpath 'config') end, { desc = 'Open nvim config dir' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode (alt to <C-\><C-n>)
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Kill terminal job
vim.keymap.set('n', '<leader>jk', function()
    if vim.bo.buftype == 'terminal' then vim.fn.jobstop(vim.bo.channel) end
end, { desc = 'Kill terminal job' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('i', '<right>', '<Nop>', { desc = 'Disable right arrow in insert mode' })

-- Split navigation: C-h/j/k/l via smart-splits.nvim (see lua/custom/plugins/smart-splits.lua)
