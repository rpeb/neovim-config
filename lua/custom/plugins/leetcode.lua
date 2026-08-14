-- Solve LeetCode problems in Neovim
-- Sign in with :Leet cookie update (paste LeetCode cookie from browser devtools)

return {
    {
        'kawre/leetcode.nvim',
        build = ':TSUpdate html',
        cmd = 'Leet',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'nvim-telescope/telescope.nvim',
        },
        opts = {
            lang = 'java',
            picker = { provider = 'telescope' },
            plugins = { non_standalone = true },
        },
        keys = {
            { '<leader>lq', '<cmd>Leet<cr>', desc = '[L]eet[Q]uery dashboard' },
        },
    },
}
