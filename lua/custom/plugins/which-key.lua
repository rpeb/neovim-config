-- Pending keybind popup
return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>u', group = '[U]I' },
        { '<leader>g', group = '[G]it diffview' },
        { '<leader>x', group = '[T]rouble' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>a', group = '[A]erial' },
        { '<leader>c', group = '[C]ode / [C]make / [C]++' },
        { '<leader>o', group = '[O]verseer / Obsidian' },
        { '<leader>l', group = '[L]eetCode' },
        { '<leader>R', group = '[R]est/Kulala' },
        { '<leader>r', group = '[R]un tasks' },
        { '<leader>j', group = '[J]ava' },
        { '<leader>m', group = '[M]aven / Build' },
        { '<leader>d', group = '[D]ebug / DAP' },
        { '<leader>t', group = '[T]est / Toggle' },
        { '<leader>f', group = '[F]ormat' },
      },
    },
  },
}
