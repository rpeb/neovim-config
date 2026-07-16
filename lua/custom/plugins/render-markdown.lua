-- Rich markdown view (headings, callouts, tables, etc.)
-- Must load on `markdown` ft — do not only pull it in via obsidian.nvim or notes outside the vault get no renderer.
return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  ft = { 'markdown' },
  opts = {
    preset = 'obsidian',
  },
}
