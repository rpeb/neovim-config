-- Git blame and diff view plugins

return {
  -- Git blame (virtual text showing who last modified each line)
  { 'f-person/git-blame.nvim', event = 'BufRead' },

  -- Diff view (tabpage interface for cycling through git diffs)
  {
    'sindrets/diffview.nvim',
    event = 'BufRead',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iffview open' },
      { '<leader>gD', '<cmd>DiffviewClose<cr>', desc = '[G]it [D]iffview close' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it [H]istory (all)' },
      { '<leader>gf', '<cmd>DiffviewFocusFiles<cr>', desc = '[G]it [F]ocus files panel' },
    },
  },
}
