-- REST/HTTP client for Neovim (HTTP, GraphQL, gRPC, WebSocket)
-- Use with .http or .rest files. Open scratchpad for quick requests.

return {
    {
        'mistweaverco/kulala.nvim',
        ft = { 'http', 'rest' },
        keys = {
            { '<leader>Rs', desc = 'Kulala: Send request' },
            { '<leader>Rb', desc = 'Kulala: Open scratchpad' },
        },
        opts = {
            global_keymaps = true,
            global_keymaps_prefix = '<leader>R',
        },
    },
}
