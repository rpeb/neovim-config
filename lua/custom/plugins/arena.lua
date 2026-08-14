return {
  'dzfrias/arena.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>ba', function() require('arena').open() end, desc = '[B]uffer [A]rena' },
  },
  opts = {
    options = {
      persistent = false,
    },
  },
}
