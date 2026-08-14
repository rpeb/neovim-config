-- Directional split navigation and resizing (works with tmux, wezterm, kitty, zellij)
-- Replaces C-h/j/k/l with multiplexer-aware movement

return {
    {
        'mrjones2014/smart-splits.nvim',
        event = 'VimEnter',
        opts = {
            ignored_filetypes = { 'NvimTree', 'aerial' },
        },
        config = function(_, opts)
            local smart_splits = require 'smart-splits'
            smart_splits.setup(opts)

            -- Resize splits (Alt+h/j/k/l)
            vim.keymap.set('n', '<A-h>', smart_splits.resize_left, { desc = 'Resize left' })
            vim.keymap.set('n', '<A-j>', smart_splits.resize_down, { desc = 'Resize down' })
            vim.keymap.set('n', '<A-k>', smart_splits.resize_up, { desc = 'Resize up' })
            vim.keymap.set('n', '<A-l>', smart_splits.resize_right, { desc = 'Resize right' })

            -- Move between splits (replaces default C-h/j/k/l with multiplexer-aware)
            vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left, { desc = 'Move to left split' })
            vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down, { desc = 'Move to lower split' })
            vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up, { desc = 'Move to upper split' })
            vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right, { desc = 'Move to right split' })
            vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous, { desc = 'Move to previous split' })

            -- Swap buffers between windows
            vim.keymap.set('n', '<leader><leader>h', smart_splits.swap_buf_left, { desc = 'Swap buffer left' })
            vim.keymap.set('n', '<leader><leader>j', smart_splits.swap_buf_down, { desc = 'Swap buffer down' })
            vim.keymap.set('n', '<leader><leader>k', smart_splits.swap_buf_up, { desc = 'Swap buffer up' })
            vim.keymap.set('n', '<leader><leader>l', smart_splits.swap_buf_right, { desc = 'Swap buffer right' })
        end,
    },
}
