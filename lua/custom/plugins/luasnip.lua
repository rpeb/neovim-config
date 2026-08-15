-- Snippet engine. Kept standalone after replacing blink.cmp with Neovim 0.12's
-- native autocomplete: vim.lsp.completion handles LSP completion (and expands
-- LSP snippet items via vim.snippet), while LuaSnip expands the user-defined
-- snippets in snippets/*.lua and friendly-snippets.
-- Tab / S-Tab expand and jump through snippets (see lua/custom/keymaps.lua).

return {
    {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
            -- Build step is needed for regex support in snippets.
            -- This step is not supported in many windows environments.
            -- Remove the below condition to re-enable on windows.
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
            return 'make install_jsregexp'
        end)(),
        dependencies = {
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_lua').load { paths = { vim.fn.stdpath 'config' .. '/snippets' } }
        end,
    },
}
