-- Highlight other uses of the word under the cursor (LSP, treesitter, or regex)
-- Default keymaps: <a-n> / <a-p> next/prev, <a-i> textobject for illuminated refs

return {
  {
    'RRethy/vim-illuminate',
    event = 'BufReadPost',
    opts = {},
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
  },
}
