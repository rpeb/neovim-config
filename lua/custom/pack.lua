-- lua/custom/pack.lua
-- Plugin driver for Neovim 0.12's built-in plugin manager (vim.pack).
--
-- The specs in lua/custom/plugins/*.lua are written in lazy.nvim style. This
-- module converts them into vim.pack specs, installs the plugins, and applies
-- each plugin's config/opts/init/keys at startup.
--
-- vim.pack has no lazy loading: every plugin loads at startup. Update plugins
-- with :VimPackUpdate (or :lua vim.pack.update()).
--
-- Plugin state (revisions) lives in nvim-pack-lock.json in this repo — commit
-- it so other machines install at the same revisions.

local M = {}

-- Flat list of plugin specs (same collector lazy's `import` used).
local specs = require 'custom.plugins'

-- Resolve the source URL of a lazy-style spec (string or table with [1]).
local function spec_src(spec)
    if type(spec) == 'string' then return spec end
    return spec.src or spec[1]
end

-- lazy.nvim expands 'owner/repo' shorthand to https://github.com/owner/repo;
-- vim.pack passes src verbatim to git clone, so expand it here.
local function full_src(src)
    if src:match '^[^/]+/[^/]+$' then return 'https://github.com/' .. src end
    return src
end

-- Plugin name, matching lazy.nvim / vim.pack conventions.
local function plugin_name(spec)
    if type(spec) == 'string' then spec = { src = spec } end
    if spec.name then return spec.name end
    return (spec_src(spec):gsub('%.git$', ''):match '[^/]+$')
end

-- Evaluate lazy-style gates.
local function is_enabled(spec)
    if spec.enabled == false then return false end
    if type(spec.enabled) == 'function' and not spec.enabled() then return false end
    if spec.cond and not spec.cond() then return false end
    return true
end

-- Collect every spec (top-level + nested dependencies), merging by plugin name.
local merged = {}
local function collect(spec)
    if type(spec) == 'string' then spec = { src = spec } end
    if not spec.src then spec = vim.tbl_extend('force', { src = spec[1] }, spec) end
    if not is_enabled(spec) then return end

    local name = plugin_name(spec)
    local entry = merged[name]
    if not entry then
        entry = { name = name, src = full_src(spec.src) }
        merged[name] = entry
    end

    -- First non-nil value wins for fields that should appear once.
    for _, field in ipairs { 'version', 'config', 'init', 'main', 'priority', 'build' } do
        if entry[field] == nil then entry[field] = spec[field] end
    end
    -- opts deep-merge (later specs override, matching lazy).
    if spec.opts ~= nil then entry.opts = entry.opts and vim.tbl_deep_extend('force', entry.opts, spec.opts) or spec.opts end
    -- keys accumulate.
    if spec.keys then
        entry.keys = entry.keys or {}
        vim.list_extend(entry.keys, spec.keys)
    end
    -- Recurse into dependencies.
    for _, dep in ipairs(spec.dependencies or {}) do
        collect(dep)
    end
end

for _, spec in ipairs(specs) do
    collect(spec)
end

-- lazy version ranges ('2.*', '*', ...) become vim.version ranges; plain
-- strings (branch/tag/commit) are passed through.
local function to_pack_version(v)
    if type(v) ~= 'string' then return v end
    if v:find '[*,<>]' then
        local ok, r = pcall(vim.version.range, v)
        if ok then return r end
    end
    return v
end

-- Build steps to run after install/update, keyed by plugin name.
local builds = {}
for name, entry in pairs(merged) do
    if entry.build then builds[name] = entry.build end
end

-- vim.pack provides no build support; hook PackChanged to collect pending
-- builds, then run them all at VimEnter (after every plugin's files are
-- sourced, so e.g. ':TSUpdate' exists).
local pending_builds = {}
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local build = builds[ev.data.spec.name]
        if not build or (ev.data.kind ~= 'install' and ev.data.kind ~= 'update') then return end
        pending_builds[#pending_builds + 1] = { name = ev.data.spec.name, path = ev.data.path }
    end,
})
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        for _, b in ipairs(pending_builds) do
            local build = builds[b.name]
            local cmd = type(build) == 'function' and build(b.path) or build
            if cmd and cmd ~= '' then
                if cmd:sub(1, 1) == ':' then
                    vim.cmd(cmd) -- Vim command build (e.g. ':TSUpdate html')
                else
                    vim.system({ 'bash', '-lc', cmd }, { cwd = b.path }):wait()
                end
            end
        end
    end,
})

-- Install / register every plugin. `confirm = false` matches the old
-- `install.missing = true` behavior (install silently, no prompt).
local pack_specs = {}
for name, entry in pairs(merged) do
    pack_specs[#pack_specs + 1] = {
        src = entry.src,
        name = name,
        version = entry.version and to_pack_version(entry.version),
    }
end
vim.pack.add(pack_specs, { confirm = false, load = true })

-- Config/init errors are non-fatal (like lazy.nvim, which reports them and
-- continues): a single broken plugin must not brick startup. Errors are
-- collected in vim.g._pack_config_errors and surfaced as notifications.
local function safe(name, fn)
    local ok, err = pcall(fn)
    if not ok then
        vim.g._pack_config_errors = vim.g._pack_config_errors or {}
        vim.g._pack_config_errors[name] = err
        vim.schedule(function() vim.notify(('Plugin `%s` failed to configure: %s'):format(name, err), vim.log.levels.ERROR) end)
    end
end

-- Run `init` hooks (they set globals/options before config).
for _, entry in pairs(merged) do
    if entry.init then safe(entry.name, entry.init) end
end

-- Resolve the Lua module to configure a plugin. lazy.nvim defaults to the
-- plugin name (with '.nvim' stripped); some plugins (e.g. better-escape.nvim)
-- use an underscore in their module name, so fall back to that variant.
local function resolve_main(entry)
    local main = entry.main or entry.name:gsub('%.nvim$', '')
    local ok, mod = pcall(require, main)
    if ok then return mod end
    main = main:gsub('%-', '_')
    ok, mod = pcall(require, main)
    if ok then return mod end
    return nil
end

-- Run configs (explicit config, or default `require(main).setup(opts)` for
-- opts-only plugins) in lazy priority order, then by name for determinism.
-- This keeps the themery (1001) restore ahead of catppuccin (1000).
local ordered = {}
for _, entry in pairs(merged) do
    if entry.config or entry.opts ~= nil then ordered[#ordered + 1] = entry end
end
table.sort(ordered, function(a, b)
    local pa, pb = a.priority or 50, b.priority or 50
    if pa ~= pb then return pa > pb end
    return a.name < b.name
end)

for _, entry in ipairs(ordered) do
    local opts = entry.opts
    safe(entry.name, function()
        if type(entry.config) == 'function' then
            entry.config(entry, opts)
        elseif entry.config == true or opts ~= nil then
            -- Default lazy behavior: require(<main>).setup(opts). Skip silently
            -- if the plugin has no matching Lua module (e.g. LuaSnip's is `luasnip`).
            local mod = resolve_main(entry)
            if mod and type(mod.setup) == 'function' then mod.setup(opts or {}) end
        end
    end)
end

-- Register `keys` from every spec. lazy-only fields (ft, cond, ...) are
-- dropped; entries without a rhs (plugins that map their own keys) are skipped.
for _, entry in pairs(merged) do
    safe(entry.name, function()
        for _, key in ipairs(entry.keys or {}) do
            local rhs = key[2]
            if rhs ~= nil then
                local km_opts = {}
                for _, k in ipairs { 'desc', 'buffer', 'silent', 'nowait', 'expr', 'script', 'noremap', 'remap', 'replace_keycodes', 'callback' } do
                    if key[k] ~= nil then km_opts[k] = key[k] end
                end
                vim.keymap.set(key.mode or 'n', key[1], rhs, km_opts)
            end
        end
    end)
end

-- Insert-mode completion keys (native autocomplete). Set here, after plugin
-- configs, so they take precedence over tabout.nvim's own <Tab>/<S-Tab> maps.
-- <Tab>/<S-Tab> move through the completion menu; LuaSnip expands/jumps
-- snippets; otherwise tabout jumps out of closing brackets (preserving its
-- feature) and the key falls through to a literal tab.
local closing = { [')'] = true, [']'] = true, ['}'] = true, ['>'] = true, ["'"] = true, ['"'] = true, ['`'] = true }
local opening = { ['('] = true, ['['] = true, ['{'] = true, ['<'] = true, ["'"] = true, ['"'] = true, ['`'] = true }

local function tabout_available(dir)
    local ok, tabout = pcall(require, 'tabout')
    if not ok or not tabout.is_enabled() then return false end
    local line = vim.fn.getline '.'
    local col = vim.fn.col '.' - 1 -- 0-based column
    if dir == 'backward' then return opening[line:sub(col, col)] == true end
    return closing[line:sub(col + 1, col + 1)] == true
end

vim.keymap.set('i', '<Tab>', function()
    if vim.fn.pumvisible() == 1 then return '<C-n>' end
    local ok, luasnip = pcall(require, 'luasnip')
    if ok and luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        return ''
    end
    if tabout_available 'forward' then
        require('tabout').tabout()
        return ''
    end
    return '<Tab>'
end, { expr = true })

vim.keymap.set('i', '<S-Tab>', function()
    if vim.fn.pumvisible() == 1 then return '<C-p>' end
    local ok, luasnip = pcall(require, 'luasnip')
    if ok and luasnip.jumpable(-1) then
        luasnip.jump(-1)
        return ''
    end
    if tabout_available 'backward' then
        require('tabout').taboutBack()
        return ''
    end
    return '<S-Tab>'
end, { expr = true })

vim.keymap.set('i', '<CR>', function()
    if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ 'selected' }).selected >= 0 then
        return '<C-y>' -- accept the highlighted completion
    end
    return '<CR>'
end, { expr = true })

-- Convenience commands mirroring the old :Lazy update / :Lazy clean.
vim.api.nvim_create_user_command('VimPackUpdate', function() vim.pack.update() end, {})
vim.api.nvim_create_user_command('VimPackClean', function()
    local stale = vim.iter(vim.pack.get()):filter(function(p) return not p.active end):map(function(p) return p.spec.name end):totable()
    if #stale > 0 then
        vim.pack.del(stale)
    else
        vim.notify('No inactive plugins to remove', vim.log.levels.INFO)
    end
end, {})

return M
