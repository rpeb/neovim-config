return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>e', '<cmd>Yazi<cr>', desc = 'Open Yazi (file manager)' },
    { '<leader>Ye', '<cmd>Yazi cwd<cr>', desc = 'Open Yazi in cwd' },
  },
  opts = {
    open_for_directories = false,
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_border = 'rounded',
    keymaps = {
      show_help = '<f1>',
      open_file_in_vertical_split = '<c-v>',
      open_file_in_horizontal_split = '<c-h>',
      open_file_in_tab = '<c-t>',
      grep_in_directory = '<c-s>',
      replace_in_directory = '<c-g>',
      cycle_open_buffers = '<tab>',
      send_to_quickfix_list = '<c-q>',
      change_working_directory = '<c-w>',
    },
  },
}
