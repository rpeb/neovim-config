--[[
  Neovim configuration.
  - Options:      lua/custom/options.lua
  - Keymaps:      lua/custom/keymaps.lua
  - Autocommands: lua/custom/autocmds.lua
  - Plugins:      lua/custom/plugins/*.lua
  - Buffer-local: ftplugin/*.lua
--]]

-- Leader key must be set before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'custom.options'
require 'custom.keymaps'
require 'custom.autocmds'

-- [[ Install lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Plugins ]]
require('lazy').setup({
    { import = 'custom.plugins' },
}, {
    -- No auto-updates: plugins only change when you run :Lazy update
    checker = { enabled = false },
    -- Install plugins declared in the spec but not on disk (e.g. new entries in custom/plugins).
    -- Set to false if you only want manually approved installs; then run :Lazy after adding a plugin.
    install = { missing = true },
    ui = {
        -- If you are using a Nerd Font: set icons to an empty table which will use the
        -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
