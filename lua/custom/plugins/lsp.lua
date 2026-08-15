-- LSP: nvim-lspconfig + mason + fidget
return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            -- Mason must be loaded before its dependents so we need to set it up here.
            { 'mason-org/mason.nvim', opts = {} },
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            {
                'j-hui/fidget.nvim',
                opts = {
                    progress = {
                        display = {
                            render_limit = 16,
                            done_ttl = 3,
                        },
                        lsp = {
                            progress_ringbuf_size = 512,
                        },
                    },
                    notification = {
                        window = {
                            winblend = 0,
                        },
                    },
                },
            },

            -- Allows extra capabilities provided by blink.cmp
            'saghen/blink.cmp',
        },
        config = function()
            -- Configure keymaps/highlights when an LSP attaches to a buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- Highlight word references on CursorHold, clear on BufLeave / LspDetach
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        -- BufLeave instead of CursorMoved to avoid flickering when navigating
                        vim.api.nvim_create_autocmd('BufLeave', {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end

                    -- Inlay hints on by default (toggle with <leader>th)
                    if client and client:supports_method('textDocument/inlayHint', event.buf) then
                        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                        map(
                            '<leader>th',
                            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end,
                            '[T]oggle Inlay [H]ints'
                        )
                    end
                end,
            })

            -- Extend default client capabilities with blink.cmp's
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            -- Enabled language servers
            local servers = {
                clangd = {
                    cmd = {
                        'clangd',
                        '--background-index',
                        '--clang-tidy',
                        '--header-insertion=iwyu',
                        '--completion-style=detailed',
                        '--function-arg-placeholders',
                        '--pch-storage=memory',
                        '--fallback-style=LLVM',
                    },
                    init_options = {
                        usePlaceholders = true,
                        clangdFileStatus = true,
                        completeUnimported = true,
                        semanticHighlighting = true,
                    },
                    root_markers = { 'compile_commands.json', 'compile_flags.txt', '.clangd', 'CMakeLists.txt', 'Makefile', '.git' },
                },
                -- gopls = {},
                -- pyright = {},
                -- rust_analyzer = {},
                -- jdtls configured in lua/custom/plugins/java.lua
                lua_ls = {
                    settings = {
                        Lua = {
                            telemetry = { enable = false },
                            -- Rich inlay hints / code context
                            hint = {
                                enable = true,
                                setType = true,
                                paramName = 'All',
                                paramType = true,
                                arrayIndex = 'Auto',
                                await = true,
                            },
                        },
                    },
                },

                -- ts_ls = {}, -- uncomment to enable TypeScript support
            }

            -- Tools auto-installed via mason-tool-installer
            require('mason-tool-installer').setup {
                ensure_installed = {
                    'lua-language-server',
                    'clang-format',
                    'google-java-format',
                    'jdtls',
                    'java-debug-adapter',
                    'java-test',
                },
            }

            for name, server in pairs(servers) do
                server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                vim.lsp.config(name, server)
                vim.lsp.enable(name)
            end

            -- Lua config, as recommended by neovim help docs
            vim.lsp.config('lua_ls', {
                on_init = function(client)
                    -- Base library: LÖVE types (for LÖVE game projects).
                    -- Applied even when the project has its own .luarc.json: lua_ls
                    -- merges config sources, and the project file still overrides any
                    -- key it sets explicitly (e.g. its own workspace.library).
                    local library = { vim.fn.expand '~/.local/share/love2d-types' }
                    -- In the Neovim config workspace, also expose Neovim core API types plus
                    -- types for the plugins this config actually uses. Indexing *every*
                    -- runtime file would scan ~3500 files and slow lua_ls down; this
                    -- curated set covers the plugins referenced in lua/custom (~1500 files).
                    -- Add new plugins here if you want their types in config files.
                    if client.workspace_folders and client.workspace_folders[1].name == vim.fn.stdpath 'config' then
                        table.insert(library, vim.env.VIMRUNTIME .. '/lua')
                        local plugin_dirs = {
                            'lazy.nvim',
                            'blink.cmp',
                            'conform.nvim',
                            'telescope.nvim',
                            'nvim-treesitter',
                            'neotest',
                            'obsidian.nvim',
                            'overseer.nvim',
                            'themery.nvim',
                            'nvim-dap',
                            'nvim-dap-ui',
                            'neogen',
                            'flash.nvim',
                            'vim-illuminate',
                            'cppman.nvim',
                            'treesj',
                            'LuaSnip',
                            'catppuccin',
                            'mini.nvim',
                            'arena.nvim',
                            'mason-tool-installer.nvim',
                            'mason-nvim-dap.nvim',
                            'colorful-menu.nvim',
                        }
                        for _, name in ipairs(plugin_dirs) do
                            local dir = vim.fn.stdpath 'data' .. '/lazy/' .. name .. '/lua'
                            if vim.fn.isdirectory(dir) == 1 then table.insert(library, dir) end
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most
                            -- likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                            -- Tell the language server how to find Lua modules same way as Neovim
                            -- (see `:h lua-module-load`)
                            path = { 'lua/?.lua', 'lua/?/init.lua' },
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = library,
                        },
                    })
                end,
            })
        end,
    },
}
