-- Configurable startup/dashboard screen
-- Disabled on startup to avoid "Cursor position outside buffer" race condition.
-- Use :Startup display or <leader>bd to show manually.
-- Custom theme: lua/startup/themes/dashboard.lua

return {
  {
    'startup-nvim/startup.nvim',
    lazy = false, -- Load at startup so config applies (avoids lazy-load timing issues)
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    keys = {
      { '<leader>bd', '<cmd>Startup display<cr>', desc = '[B]uffer [D]ashboard' },
    },
    config = function()
      vim.g.startup_disable_on_startup = false -- Show dashboard on startup
      -- theme = 'dashboard' loads lua/startup/themes/dashboard.lua from config (our override)
      require('startup').setup({ theme = 'dashboard' })
    end,
  },
}
