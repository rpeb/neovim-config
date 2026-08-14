-- Custom per-template directory support for obsidian.nvim
-- Adapted from nvim_ancient/lua/exosyphon/obsidian-templates.lua

local M = {}

M.templates = {
    -- Quartz: copies to ~/repos/quartz/content via sync-from-obsidian.py --folder
    publish = {
        template = 'publish',
        directory = 'staging',
        command = 'ObsidianNewPublish',
    },
    meeting = {
        template = 'meeting',
        directory = 'notes/meetings',
        command = 'ObsidianNewMeeting',
    },
    thought = {
        template = 'thoughts',
        directory = 'thoughts',
        command = 'ObsidianNewThought',
    },
    post = {
        template = 'notes',
        directory = 'posts',
        command = 'ObsidianNewPost',
    },
}

local function create_note_with_template(template_config, title)
    local Note = require 'obsidian.note'
    local Obsidian = require('obsidian').get_client()

    if not Obsidian then
        vim.notify('Obsidian not initialized', vim.log.levels.ERROR)
        return
    end

    if not title or title == '' then
        title = vim.fn.input 'Note title: '
        if title == '' then
            vim.notify('Note creation cancelled', vim.log.levels.INFO)
            return
        end
    end

    local note = Note.create {
        id = title,
        dir = Obsidian.dir / template_config.directory,
        should_write = true,
        template = template_config.template,
    }

    if not note then
        vim.notify('Failed to create note', vim.log.levels.ERROR)
        return
    end

    vim.cmd('edit ' .. tostring(note.path))
    vim.notify(string.format("Created note '%s' in %s", title, template_config.directory), vim.log.levels.INFO)
end

function M.setup()
    for key, config in pairs(M.templates) do
        local command_name = config.command or ('ObsidianNew' .. key:sub(1, 1):upper() .. key:sub(2))

        vim.api.nvim_create_user_command(command_name, function(opts)
            local title = opts.args ~= '' and opts.args or nil
            create_note_with_template(config, title)
        end, {
            nargs = '?',
            desc = string.format('Create new note in %s using %s template', config.directory, config.template),
        })
    end
end

return M
