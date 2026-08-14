-- Global autocommands

-- Java: no listchars (window-local)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    vim.wo.list = false
  end,
  group = vim.api.nvim_create_augroup('java-no-listchars', { clear = true }),
})

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Start terminal in insert mode
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Auto enter insert mode when opening a terminal',
  group = vim.api.nvim_create_augroup('terminal-insert', { clear = true }),
  pattern = '*',
  callback = function()
    vim.defer_fn(function()
      if vim.bo.buftype == 'terminal' then
        vim.cmd.startinsert()
      end
    end, 100)
  end,
})

-- Autosave: save buffers when leaving them or when Neovim loses focus
--  Skips buffers that aren't real files (terminal, quickfix, nofile, unnamed, etc.)
local autosave_group = vim.api.nvim_create_augroup('autosave', { clear = true })

local function is_autosaveable(buf)
  return vim.bo[buf].modified
    and vim.bo[buf].buftype == ''
    and vim.api.nvim_buf_get_name(buf) ~= ''
end

-- Save all modified file buffers when the window loses focus
--  (clicking away from the terminal / switching to another app)
vim.api.nvim_create_autocmd('FocusLost', {
  desc = 'Autosave all modified buffers on focus loss',
  group = autosave_group,
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if is_autosaveable(buf) then
        vim.api.nvim_buf_call(buf, function() vim.cmd 'silent! write' end)
      end
    end
  end,
})

-- Save the current buffer when switching away from it
vim.api.nvim_create_autocmd('BufLeave', {
  desc = 'Autosave current buffer on buffer change',
  group = autosave_group,
  callback = function(args)
    if is_autosaveable(args.buf) then
      vim.api.nvim_buf_call(args.buf, function() vim.cmd 'silent! write' end)
    end
  end,
})
