-- Distraction-free coding mode

return {
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        options = {
          number = false,
          relativenumber = false,
        },
      },
    },
    keys = {
      { '<leader>tz', '<cmd>ZenMode<cr>', desc = '[T]oggle [Z]en mode' },
    },
  },
}
