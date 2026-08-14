return {
  'abecodes/tabout.nvim',
  event = 'InsertEnter',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    tabkey = '<Tab>',
    backwards_shiftkey = '<S-Tab>',
    act_as_tab = true,
    act_as_shift_tab = false,
    enable_arrow_key_movement = true,
    tabouts = {
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = '`', close = '`' },
      { open = '(', close = ')' },
      { open = '[', close = ']' },
      { open = '{', close = '}' },
      { open = '<', close = '>' },
    },
    ignore_beginning = true,
    exclude = {},
  },
}
