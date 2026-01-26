-- Custom per-template directory support for obsidian.nvim
-- This module allows you to define templates with specific directories
-- and creates custom commands for each template

local M = {}

-- Configuration: Define your templates and their directories here
-- Each template should specify:
--   - template: name of the template file (in your templates folder)
--   - directory: path relative to vault root where notes should be created
--   - command: (optional) custom command name, defaults to "ObsidianNew{Key}"
M.templates = {
  meeting = {
    template = "templates/meeting.md",
    directory = "notes/meetings",
    command = "ObsidianNewMeeting",
  },
  thought = {
    template = "templates/note.md",
    directory = "thoughts",
    command = "ObsidianNewThought",
  },
  post = {
    template = "templates/note.md",
    directory = "posts",
    command = "ObsidianNewPost",
  },
  -- Add more templates as needed
}

-- Helper function to create a note in a specific directory with a template
---@param template_config table The template configuration
---@param title string|nil Optional title for the note
local function create_note_with_template(template_config, title)
  local obsidian = require("obsidian")
  local client = obsidian.get_client()
  
  if not client then
    vim.notify("Obsidian client not initialized", vim.log.levels.ERROR)
    return
  end

  -- Prompt for title if not provided
  if not title or title == "" then
    title = vim.fn.input("Note title: ")
    if title == "" then
      vim.notify("Note creation cancelled", vim.log.levels.INFO)
      return
    end
  end

  -- Create the full path for the note
  local note_path = template_config.directory .. "/" .. title
  
  -- Create a new note using obsidian's API
  -- The note will be created in the specified directory
  local note = client:create_note({
    title = title,
    dir = client.dir / template_config.directory,
    no_write = false,
  })

  if not note then
    vim.notify("Failed to create note", vim.log.levels.ERROR)
    return
  end

  -- Open the note in a buffer
  vim.cmd("edit " .. tostring(note.path))

  -- Apply the template
  vim.schedule(function()
    vim.cmd("ObsidianTemplate " .. template_config.template)
  end)

  vim.notify(
    string.format("Created note '%s' in %s", title, template_config.directory),
    vim.log.levels.INFO
  )
end

-- Setup function to create all custom commands
function M.setup()
  for key, config in pairs(M.templates) do
    local command_name = config.command or ("ObsidianNew" .. key:sub(1, 1):upper() .. key:sub(2))
    
    vim.api.nvim_create_user_command(command_name, function(opts)
      local title = opts.args ~= "" and opts.args or nil
      create_note_with_template(config, title)
    end, {
      nargs = "?",
      desc = string.format(
        "Create a new note in %s using %s template",
        config.directory,
        config.template
      ),
    })
  end

  vim.notify(
    string.format("Loaded %d custom Obsidian templates", vim.tbl_count(M.templates)),
    vim.log.levels.INFO
  )
end

return M
