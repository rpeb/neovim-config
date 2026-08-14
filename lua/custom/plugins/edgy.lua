-- Predefined edge window layouts (neo-tree, Trouble, aerial, etc.)

return {
    {
        'folke/edgy.nvim',
        event = 'VeryLazy',
        init = function()
            vim.opt.laststatus = 3
            vim.opt.splitkeep = 'screen'
        end,
        opts = {
            left = {},
            bottom = {
                'Trouble',
                { ft = 'qf', title = 'QuickFix' },
                {
                    ft = 'help',
                    size = { height = 20 },
                    filter = function(buf) return vim.bo[buf].buftype == 'help' end,
                },
            },
            right = {
                {
                    title = 'Aerial',
                    ft = 'aerial',
                    pinned = true,
                    open = 'AerialOpen',
                },
            },
        },
    },
}
