-- Pretty list for diagnostics, quickfix, location list, and LSP

return {
    {
        'folke/trouble.nvim',
        cmd = 'Trouble',
        opts = {},
        keys = {
            { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = '[T]rouble diagnostics' },
            { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = '[T]rouble buffer diagnostics' },
            { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = '[T]rouble location list' },
            { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = '[T]rouble quickfix list' },
            { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = '[T]rouble [S]ymbols' },
            { '<leader>xr', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = '[T]rouble LSP [R]eferences' },
        },
    },
}
