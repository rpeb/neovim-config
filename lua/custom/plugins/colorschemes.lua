-- Colorschemes and Themery for switching between them
-- Open with :Themery to switch (selection is persistent across sessions)

return {
    -- Catppuccin (default theme; switch with :Themery)
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        config = function()
            require('catppuccin').setup {
                flavour = 'mocha',
                no_italic = true,
                integrations = {
                    gitsigns = true,
                    mason = true,
                    mini = { enabled = true },
                    native_lsp = { enabled = true },
                    telescope = { enabled = true },
                    treesitter = true,
                    which_key = true,
                },
            }
            -- Only apply catppuccin if Themery hasn't restored a saved theme
            -- (first run / no state file). Otherwise Themery's saved theme would
            -- be clobbered, since catppuccin (priority 1000) loads after Themery (1001).
            if not vim.g.theme_id then vim.cmd.colorscheme 'catppuccin' end
        end,
    },

    -- Nord
    { 'shaunsingh/nord.nvim', lazy = false, priority = 1000 },

    -- Kanagawa
    { 'rebelot/kanagawa.nvim', lazy = false, priority = 1000 },

    -- Material
    { 'marko-cerovac/material.nvim', lazy = false, priority = 1000 },

    -- Everforest
    { 'sainnhe/everforest', lazy = false, priority = 1000 },

    -- One Dark Pro
    { 'olimorris/onedarkpro.nvim', lazy = false, priority = 1000 },

    -- GitHub theme
    { 'projekt0n/github-nvim-theme', lazy = false, priority = 1000 },

    -- Bamboo (dark green theme)
    { 'ribru17/bamboo.nvim', lazy = false, priority = 1000 },

    -- Gruvbox
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
        config = function() vim.g.gruvbox_contrast = 'dark' end,
    },

    -- Monokai
    { 'tanvirtin/monokai.nvim', lazy = false, priority = 1000 },

    -- Tokyo Night
    { 'folke/tokyonight.nvim', lazy = false, priority = 1000 },

    -- Rosé Pine
    { 'rose-pine/neovim', lazy = false, priority = 1000 },

    -- Nightfox (fox-themed palettes)
    { 'EdenEast/nightfox.nvim', lazy = false, priority = 1000 },

    -- Dracula
    { 'Mofiqul/dracula.nvim', lazy = false, priority = 1000 },

    -- Gruvbox Material (softer gruvbox, 3 contrast palettes)
    { 'sainnhe/gruvbox-material', lazy = false, priority = 1000 },

    -- Sonokai (high-contrast, vivid, Monokai Pro-inspired)
    { 'sainnhe/sonokai', lazy = false, priority = 1000 },

    -- Oxocarbon (IBM Carbon Design System)
    { 'nyoom-engineering/oxocarbon.nvim', lazy = false, priority = 1000 },

    -- Solarized 8
    { 'lifepillar/vim-solarized8', lazy = false, priority = 1000 },

    -- Themery: switch between colorschemes (persistent)
    {
        'zaldih/themery.nvim',
        lazy = false,
        priority = 1001,
        config = function()
            require('themery').setup {
                themes = {
                    'catppuccin',
                    'nord',
                    'kanagawa',
                    'kanagawa-dragon',
                    'kanagawa-wave',
                    'kanagawa-lotus',
                    'material-darker',
                    'material-lighter',
                    'material-oceanic',
                    'material-palenight',
                    'everforest',
                    'onedark',
                    'onedark_dark',
                    'onedark_vivid',
                    'onelight',
                    'github_dark',
                    'github_light',
                    'github_dark_dimmed',
                    'github_light_default',
                    'bamboo',
                    'gruvbox',
                    'monokai',
                    'monokai_pro',
                    'monokai_soda',
                    'monokai_ristretto',

                    -- Tokyo Night
                    'tokyonight',
                    'tokyonight-night',
                    'tokyonight-storm',
                    'tokyonight-moon',
                    'tokyonight-day',

                    -- Rosé Pine
                    'rose-pine',
                    'rose-pine-moon',
                    'rose-pine-dawn',

                    -- Nightfox
                    'nightfox',
                    'dayfox',
                    'dawnfox',
                    'duskfox',
                    'nordfox',
                    'terafox',
                    'carbonfox',

                    -- Dracula
                    'dracula',

                    -- Oxocarbon
                    'oxocarbon',

                    -- Solarized 8
                    'solarized8',
                    'solarized8_flat',
                    'solarized8_high',
                    'solarized8_low',
                    {
                        name = 'solarized8 (light)',
                        colorscheme = 'solarized8',
                        before = [[vim.opt.background = 'light']],
                    },

                    -- Everforest light (dark is the plain 'everforest' entry)
                    {
                        name = 'everforest (light)',
                        colorscheme = 'everforest',
                        before = [[vim.g.everforest_background = 'light']],
                    },

                    -- Gruvbox Material (contrast palettes via g:gruvbox_material_background)
                    {
                        name = 'gruvbox-material (hard)',
                        colorscheme = 'gruvbox-material',
                        before = [[vim.g.gruvbox_material_background = 'hard']],
                    },
                    {
                        name = 'gruvbox-material (medium)',
                        colorscheme = 'gruvbox-material',
                        before = [[vim.g.gruvbox_material_background = 'medium']],
                    },
                    {
                        name = 'gruvbox-material (soft)',
                        colorscheme = 'gruvbox-material',
                        before = [[vim.g.gruvbox_material_background = 'soft']],
                    },

                    -- Sonokai (style variants via g:sonokai_style)
                    {
                        name = 'sonokai',
                        colorscheme = 'sonokai',
                        before = [[vim.g.sonokai_style = 'default']],
                    },
                    {
                        name = 'sonokai (atlantis)',
                        colorscheme = 'sonokai',
                        before = [[vim.g.sonokai_style = 'atlantis']],
                    },
                    {
                        name = 'sonokai (andromeda)',
                        colorscheme = 'sonokai',
                        before = [[vim.g.sonokai_style = 'andromeda']],
                    },
                    {
                        name = 'sonokai (shusia)',
                        colorscheme = 'sonokai',
                        before = [[vim.g.sonokai_style = 'shusia']],
                    },
                    {
                        name = 'sonokai (maia)',
                        colorscheme = 'sonokai',
                        before = [[vim.g.sonokai_style = 'maia']],
                    },
                    {
                        name = 'sonokai (espresso)',
                        colorscheme = 'sonokai',
                        before = [[vim.g.sonokai_style = 'espresso']],
                    },
                },
                livePreview = true,
            }
            vim.keymap.set('n', '<leader>tc', '<cmd>Themery<cr>', { desc = '[T]heme [C]hooser (Themery)' })
        end,
    },
}
