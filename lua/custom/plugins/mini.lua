-- mini.nvim: textobjects + statusline
return {
    {
        'nvim-mini/mini.nvim',
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Statusline
            local statusline = require 'mini.statusline'
            statusline.setup {
                use_icons = vim.g.have_nerd_font,
                content = {
                    active = function()
                        local args = { trunc_width = 120 }
                        local mode, mode_hl = statusline.section_mode(args)
                        local diff = statusline.section_diff(args)
                        local diagnostics = statusline.section_diagnostics(args)
                        local filename = statusline.section_filename(args)
                        local fileinfo = statusline.section_fileinfo(args)
                        local location = statusline.section_location(args)

                        local lsp_msg = vim.g._lsp_progress_msg or ''

                        return statusline.combine_groups {
                            { hl = mode_hl, strings = { mode } },
                            '%<',
                            { hl = 'MiniStatuslineFilename', strings = { filename } },
                            '%=',
                            diagnostics ~= '' and { strings = { diagnostics } } or {},
                            diff ~= '' and { strings = { diff } } or {},
                            lsp_msg ~= '' and { hl = 'MiniStatuslineDevinfo', strings = { lsp_msg } } or {},
                            fileinfo ~= '' and { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } } or {},
                            { hl = mode_hl, strings = { location } },
                        }
                    end,
                },
            }

            -- Track LSP progress messages for statusline display
            -- Sticky indicator: polls .cache/clangd/index/ every 5s until clangd says done
            vim.g._lsp_progress_msg = ''
            local index_timer = vim.uv.new_timer()

            local function get_indexed_vs_total()
                local cache_dir = vim.fn.getcwd() .. '/.cache/clangd/index'
                local db = vim.fn.getcwd() .. '/compile_commands.json'
                if vim.fn.isdirectory(cache_dir) == 0 or vim.fn.filereadable(db) == 0 then return -1, 0 end

                local ok, data = pcall(vim.fn.readfile, db)
                if not ok then return -1, 0 end

                local files = {}
                for line in table.concat(data):gmatch '"file"%s*:%s*"([^"]+)"' do
                    local basename = vim.fn.fnamemodify(line, ':t')
                    table.insert(files, basename)
                end

                local idx_files = {}
                local scanner = vim.uv.fs_scandir(cache_dir)
                if scanner then
                    while true do
                        local name = vim.uv.fs_scandir_next(scanner)
                        if not name then break end
                        if name:match '%.idx$' then
                            local src = name:gsub('%.[^%.]+%.idx$', '')
                            idx_files[src] = true
                        end
                    end
                end

                local indexed = 0
                for _, basename in ipairs(files) do
                    if idx_files[basename] then indexed = indexed + 1 end
                end

                return indexed, #files
            end

            local function start_index_poll()
                index_timer:start(
                    0,
                    5000,
                    vim.schedule_wrap(function()
                        local indexed, total = get_indexed_vs_total()
                        if indexed < 0 then return end
                        vim.g._lsp_progress_msg = 'indexing ' .. indexed .. '/' .. total
                        vim.cmd.redrawstatus()
                    end)
                )
            end

            local function stop_index_poll()
                index_timer:stop()
                vim.g._lsp_progress_msg = ''
                vim.cmd.redrawstatus()
            end

            -- Stop when clangd reports background indexing finished
            vim.api.nvim_create_autocmd('LspProgress', {
                callback = function(ev)
                    local params = ev.data and ev.data.params
                    if not params or not params.value then return end
                    if params.token ~= 'backgroundIndexProgress' then return end
                    if params.value.kind == 'end' then stop_index_poll() end
                end,
            })

            -- Start polling when clangd attaches
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if client and client.name == 'clangd' then
                        local indexed, total = get_indexed_vs_total()
                        if indexed >= 0 then
                            vim.g._lsp_progress_msg = 'indexing ' .. indexed .. '/' .. total
                            vim.cmd.redrawstatus()
                        end
                        start_index_poll()
                    end
                end,
            })
        end,
    },
}
