-- Peek at buffer lines when entering :number (e.g. :15 to jump)

return {
  { 'nacro90/numb.nvim', event = 'CmdlineEnter', opts = {} },
}
