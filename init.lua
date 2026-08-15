--[[
  Neovim configuration.
  - Options:      lua/custom/options.lua
  - Keymaps:      lua/custom/keymaps.lua
  - Autocommands: lua/custom/autocmds.lua
  - Plugins:      lua/custom/plugins/*.lua (managed by the built-in vim.pack)
  - Buffer-local: ftplugin/*.lua
--]]

-- Leader key must be set before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'custom.options'
require 'custom.keymaps'
require 'custom.autocmds'

-- [[ Plugins: Neovim 0.12 built-in plugin manager (vim.pack) ]]
-- Installs plugins into site/pack/core/opt and tracks revisions in
-- nvim-pack-lock.json. Plugins are installed/registered and configured by
-- lua/custom/pack.lua (a thin driver over vim.pack).
require 'custom.pack'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
