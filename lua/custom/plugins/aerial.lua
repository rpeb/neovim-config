-- Code outline/symbols sidebar (LSP + Treesitter)

return {
  {
    'stevearc/aerial.nvim',
    cmd = { 'AerialToggle', 'AerialOpen', 'AerialClose' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
    keys = {
      { '<leader>ao', '<cmd>AerialToggle<cr>', desc = '[A]erial [O]utline toggle' },
    },
  },
}
