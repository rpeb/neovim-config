-- Frecent file search (frequency + recency) - smarter than oldfiles
-- Requires sql.nvim for SQLite storage

return {
  {
    'nvim-telescope/telescope-frecency.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'tami5/sql.nvim',
    },
    config = function()
      require('telescope').load_extension 'frecency'
    end,
    keys = {
      { '<leader>sF', '<cmd>Telescope frecency<cr>', desc = '[S]earch [F]recency' },
    },
  },
}
