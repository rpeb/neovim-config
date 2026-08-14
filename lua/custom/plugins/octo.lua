-- GitHub issues, PRs, and discussions in Neovim
-- Requires: GitHub CLI (gh) authenticated

return {
    {
        'pwntester/octo.nvim',
        cmd = 'Octo',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            picker = 'telescope',
            enable_builtin = true,
        },
        keys = {
            { '<leader>goi', '<cmd>Octo issue list<cr>', desc = '[G]itHub [O]cto [I]ssues' },
            { '<leader>gop', '<cmd>Octo pr list<cr>', desc = '[G]itHub [O]cto [P]ull requests' },
            { '<leader>god', '<cmd>Octo discussion list<cr>', desc = '[G]itHub [O]cto [D]iscussions' },
            { '<leader>gon', '<cmd>Octo notification list<cr>', desc = '[G]itHub [O]cto [N]otifications' },
        },
    },
}
