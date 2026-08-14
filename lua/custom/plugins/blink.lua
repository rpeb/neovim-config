-- Autocompletion (blink.cmp + LuaSnip)
return {
  {
    'saghen/blink.cmp',
    -- Must load before LSP attaches (e.g. jdtls from ftplugin/java.lua). With event = 'VimEnter',
    -- opening `nvim Foo.java` runs ftplugin before VimEnter, so blink was not loaded and
    -- jdtls started without snippet/cmp capabilities.
    lazy = false,
    priority = 999,
    version = '1.*',
    dependencies = {
      {
        'xzbdmw/colorful-menu.nvim',
        config = function()
          require('colorful-menu').setup {}
        end,
      },
      -- Snippet engine
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
          -- Must be a dependency of LuaSnip (not a separate spec with only lazy=true), otherwise
          -- lazy.nvim has no trigger and it stays "not loaded" in :Lazy.
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
              require('luasnip.loaders.from_lua').load { paths = { vim.fn.stdpath 'config' .. '/snippets' } }
            end,
          },
        },
        opts = {},
      },
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<Enter>'] = { 'accept', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
        menu = {
          draw = {
            columns = { { 'kind_icon' }, { 'label', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = { implementation = 'lua' },

      signature = { enabled = true },
    },
  },
}
