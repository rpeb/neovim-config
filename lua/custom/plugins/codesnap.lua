-- Pretty code snapshots for sharing (select lines in visual mode, then take snapshot)

return {
  {
    'mistricky/codesnap.nvim',
    cmd = { 'CodeSnap', 'CodeSnapSave', 'CodeSnapASCII', 'CodeSnapHighlight', 'CodeSnapSaveHighlight' },
    opts = {
      save_path = vim.fn.expand '~/Pictures/',
    },
    keys = {
      { '<leader>cs', '<cmd>CodeSnap<cr>', mode = 'x', desc = '[C]ode[S]nap to clipboard' },
      { '<leader>cS', '<cmd>CodeSnapSave<cr>', mode = 'x', desc = '[C]ode[S]nap save to file' },
      { '<leader>cA', '<cmd>CodeSnapASCII<cr>', mode = 'x', desc = '[C]odeSnap [A]SCI to clipboard' },
    },
  },
}
