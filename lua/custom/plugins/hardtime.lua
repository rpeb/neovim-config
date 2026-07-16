-- Break bad Vim habits: blocks repeated j/k/h/l, suggests better motions (5j, w, b, etc.)

return {
  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
}
