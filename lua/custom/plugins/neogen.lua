-- Generate annotations and documentation (function, class, type, file)

return {
  {
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
    keys = {
      {
        '<leader>cn',
        function()
          require('neogen').generate {}
        end,
        desc = '[C]ode [N]eogen annotation',
      },
    },
  },
}
