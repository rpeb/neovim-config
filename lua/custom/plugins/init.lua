-- Merge every `*.lua` sibling into the lazy spec (see `import = 'custom.plugins'` in init.lua).
local spec = {}
local dir = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h')

for name, ftype in vim.fs.dir(dir) do
    if ftype == 'file' and name:match '%.lua$' and name ~= 'init.lua' then
        local modname = name:gsub('%.lua$', '')
        local ok, mod = pcall(require, 'custom.plugins.' .. modname)
        if ok and type(mod) == 'table' and next(mod) ~= nil then
            if type(mod[1]) == 'table' then
                for _, item in ipairs(mod) do
                    spec[#spec + 1] = item
                end
            else
                spec[#spec + 1] = mod
            end
        elseif not ok then
            vim.schedule(function() vim.notify('custom.plugins: ' .. modname .. ': ' .. tostring(mod), vim.log.levels.ERROR) end)
        end
    end
end

return spec
