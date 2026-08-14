return {
  'kosayoda/nvim-lightbulb',
  event = 'LspAttach',
  opts = {
    autocmd = { enabled = true },
    sign = { enabled = true, text = ' ' },
    virtual_text = { enabled = false },
  },
}
