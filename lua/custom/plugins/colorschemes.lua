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
          blink_cmp = true,
          gitsigns = true,
          mason = true,
          mini = { enabled = true },
          native_lsp = { enabled = true },
          telescope = { enabled = true },
          treesitter = true,
          which_key = true,
        },
      }
      vim.cmd.colorscheme 'catppuccin'
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
    config = function()
      vim.g.gruvbox_contrast = 'dark'
    end,
  },

  -- Monokai
  { 'tanvirtin/monokai.nvim', lazy = false, priority = 1000 },

  -- Astral: colorscheme persistence (remembers & restores last theme)
  { 'rootiest/astral.nvim', lazy = false, priority = 1001, opts = {} },

  -- Themery: switch between colorschemes (persistent)
  {
    'zaldih/themery.nvim',
    lazy = false,
    priority = 1001,
    config = function()
      require('themery').setup({
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
        },
        livePreview = true,
      })
      vim.keymap.set('n', '<leader>tc', '<cmd>Themery<cr>', { desc = '[T]heme [C]hooser (Themery)' })
    end,
  },
}
