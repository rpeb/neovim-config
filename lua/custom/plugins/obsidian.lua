-- Obsidian.nvim: only for vault paths (not every README.md in git repos).
-- Markdown rendering is `lua/custom/plugins/render-markdown.lua` (ft=markdown), not tied to this plugin.
-- Reference: ~/.config/nvim_ancient
local function norm(p) return vim.fs.normalize(vim.fn.expand(p)) end

-- Add paths you use as Obsidian vaults; plugin loads when opening .md under any of them.
local vault_paths = {
    norm '~/Documents/obsidian-vault',
    norm '~/Nextcloud/ObsidianVault',
    norm '~/Documents/ubvault',
}

-- `vault/**/*.md` does NOT match `vault/note.md` at the vault root — add `/*.md` too.
local patterns = {}
for _, v in ipairs(vault_paths) do
    patterns[#patterns + 1] = ('%s/*.md'):format(v)
    patterns[#patterns + 1] = ('%s/**/*.md'):format(v)
end

-- One autocmd: BufReadPre | BufNewFile, all patterns (lazy.nvim supports pattern = string[]).
local vault_md_events = {
    { event = { 'BufReadPre', 'BufNewFile' }, pattern = patterns },
}

local workspaces = {}
for _, path in ipairs(vault_paths) do
    if vim.uv.fs_stat(path) then workspaces[#workspaces + 1] = {
        name = vim.fn.fnamemodify(path, ':t'),
        path = path,
    } end
end
if #workspaces == 0 then workspaces = { { name = 'ObsidianVault', path = vault_paths[1] } } end

return {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    lazy = true,
    -- Load when touching a vault markdown file, or when you run :Obsidian … first.
    event = vault_md_events,
    cmd = 'Obsidian',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        require('obsidian').setup {
            workspaces = workspaces,
            notes_subdir = 'inbox',
            new_notes_location = 'notes_subdir',
            daily_notes = {
                folder = 'notes/dailies',
                date_format = '%Y-%m-%d',
                alias_format = '%B %-d, %Y',
                default_tags = { 'daily-notes' },
                template = 'daily.md',
            },
            attachments = {
                folder = 'assets/imgs',
                img_name_func = function() return string.format('Pasted image %s', os.date '%Y%m%d%H%M%S') end,
                img_text_func = function(client, path)
                    path = client:vault_relative_path(path) or path
                    return string.format('![%s](%s)', path.name, path)
                end,
            },
            note_id_func = function(title)
                local suffix = ''
                if title ~= nil then
                    suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
                else
                    for _ = 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                end
                return tostring(os.time()) .. '-' .. suffix
            end,
            templates = {
                subdir = 'templates',
                date_format = '%Y-%m-%d',
                time_format = '%H:%M',
                tags = '',
                substitutions = {
                    yesterday = function() return os.date('%Y-%m-%d', os.time() - 86400) end,
                    tomorrow = function() return os.date('%Y-%m-%d', os.time() + 86400) end,
                },
            },
            open = { use_advanced_uri = true },
            log_level = vim.log.levels.INFO,
            ui = { enable = false }, -- using render-markdown.nvim
            frontmatter = { enabled = false },
            legacy_commands = false,
        }

        require('custom.obsidian-templates').setup()

        -- Keymaps (reference: nvim_ancient remaps)
        vim.keymap.set('n', '<leader>oc', '<cmd>lua require("obsidian").util.toggle_checkbox()<CR>', { desc = 'Obsidian [C]heckbox' })
        vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian new_from_template<CR>', { desc = 'Obsidian [T]emplate' })
        vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<CR>', { desc = 'Obsidian [B]acklinks' })
        vim.keymap.set('n', '<leader>ol', '<cmd>Obsidian links<CR>', { desc = 'Obsidian [L]inks' })
        vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<CR>', { desc = 'Obsidian [N]ew note' })
        vim.keymap.set('n', '<leader>oq', '<cmd>Obsidian quick_switch<CR>', { desc = 'Obsidian [Q]uick switch' })
        vim.keymap.set('n', '<leader>of', '<cmd>Obsidian follow_link<CR>', { desc = 'Obsidian [F]ollow link' })
        vim.keymap.set('n', '<leader>od', '<cmd>Obsidian dailies<CR>', { desc = 'Obsidian [D]ailies' })
        vim.keymap.set('n', '<leader>ott', '<cmd>Obsidian tags<CR>', { desc = 'Obsidian [T]ags' })
        vim.keymap.set('n', '<leader>otoc', '<cmd>Obsidian toc<CR>', { desc = 'Obsidian [T]able of contents' })
        vim.keymap.set('n', '<leader>opi', '<cmd>Obsidian paste_img<CR>', { desc = 'Obsidian [P]aste [I]mage' })
        vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<CR>', { desc = 'Obsidian [S]earch' })
        vim.keymap.set('n', '<leader>oo', function()
            local root = workspaces[1] and workspaces[1].path or vault_paths[1]
            vim.cmd('cd ' .. root)
        end, { desc = 'Obsidian open vault dir' })
    end,
}
