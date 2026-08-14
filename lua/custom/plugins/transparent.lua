-- Remove background colors for transparent Neovim (nice with transparent terminal)

return {
    {
        'xiyaowong/transparent.nvim',
        lazy = false,
        opts = {
            extra_groups = {
                'NormalFloat',
                'NeoTreeNormal',
            },
        },
        keys = {
            { '<leader>ut', '<cmd>TransparentToggle<cr>', desc = '[U]I [T]ransparent toggle' },
        },
    },
}
