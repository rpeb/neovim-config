-- Shared utilities for C and C++ ftplugins

local M = {}

-- Detect project type and return build commands
function M.detect_project()
    local cwd = vim.fn.getcwd()
    local root = vim.fs.find({ 'CMakeLists.txt', 'Makefile', 'meson.build', 'compile_commands.json', '.git' }, {
        upward = true,
        type = 'file',
        path = cwd,
    })[1]

    if not root then return 'standalone' end
    local name = vim.fn.fnamemodify(root, ':t')

    if name == 'CMakeLists.txt' then return 'cmake' end
    if name == 'Makefile' then return 'make' end
    if name == 'meson.build' then return 'meson' end
    if name == 'compile_commands.json' then return 'compile_commands' end
    return 'project'
end

-- Get the compile command for a standalone file
function M.get_compile_cmd(file, opts)
    opts = opts or {}
    local compiler = opts.compiler or (vim.bo.filetype == 'cpp' and 'g++' or 'gcc')
    local std = opts.std or (vim.bo.filetype == 'cpp' and '-std=c++20' or '-std=c11')
    local flags = opts.flags or '-Wall -Wextra -O2'
    local debug_flags = opts.debug and '-g -fsanitize=address' or ''
    local exe = vim.fn.fnamemodify(file, ':t:r')
    local out = opts.out or exe

    return string.format('%s %s %s %s "%s" -o "%s"', compiler, std, flags, debug_flags, file, out)
end

-- Build and run a standalone C/C++ file
function M.build_and_run(opts)
    opts = opts or {}
    local file = vim.api.nvim_buf_get_name(0)
    if file == '' then
        vim.notify('No file to compile', vim.log.levels.ERROR)
        return
    end

    local ft = vim.bo.filetype
    local compiler = opts.compiler or (ft == 'cpp' and 'g++' or 'gcc')
    local std = opts.std or (ft == 'cpp' and '-std=c++20' or '-std=c11')
    local flags = opts.flags or '-Wall -Wextra -O2'
    local debug_flags = opts.debug and '-g -fsanitize=address,undefined' or ''
    local exe = vim.fn.fnamemodify(file, ':t:r')
    local dir = vim.fn.fnamemodify(file, ':h')
    local run_args = opts.args or ''

    local cmd =
        string.format('cd "%s" && %s %s %s %s "%s" -o "%s" && ./%s %s; rm -f "%s"', dir, compiler, std, flags, debug_flags, file, exe, exe, run_args, exe)

    vim.cmd('botright split | term ' .. cmd)
end

-- Build standalone file for debugging (keeps binary)
function M.build_for_debug()
    local file = vim.api.nvim_buf_get_name(0)
    if file == '' then
        vim.notify('No file', vim.log.levels.ERROR)
        return
    end

    local ft = vim.bo.filetype
    local compiler = ft == 'cpp' and 'g++' or 'gcc'
    local std = ft == 'cpp' and '-std=c++20' or '-std=c11'
    local exe = vim.fn.fnamemodify(file, ':t:r')
    local dir = vim.fn.fnamemodify(file, ':h')

    local cmd = string.format('cd "%s" && %s %s -g -Wall -Wextra "%s" -o "%s" && echo "Build OK: ./%s"', dir, compiler, std, file, exe, exe)

    vim.cmd('botright split | term ' .. cmd)
end

-- Quick build with cmake in build/ directory
function M.cmake_build(opts)
    opts = opts or {}
    local build_type = opts.type or 'Debug'
    local jobs = opts.jobs or vim.uv.os_available_parallelism() or 4

    local cmd = string.format('cmake -B build -DCMAKE_BUILD_TYPE=%s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build -j%d', build_type, jobs)

    vim.cmd('botright split | term ' .. cmd)
end

-- Header/source switch for C/C++
function M.switch_header()
    local file = vim.api.nvim_buf_get_name(0)
    local ext = vim.fn.fnamemodify(file, ':e')
    local base = vim.fn.fnamemodify(file, ':r')

    local alternatives = {
        c = { 'h', 'hpp' },
        h = { 'c', 'cpp' },
        cpp = { 'h', 'hpp' },
        hpp = { 'cpp', 'cc' },
        cc = { 'h', 'hpp' },
    }

    local alts = alternatives[ext]
    if not alts then
        vim.notify('Not a C/C++ file', vim.log.levels.WARN)
        return
    end

    for _, alt in ipairs(alts) do
        local target = base .. '.' .. alt
        if vim.fn.filereadable(target) == 1 then
            vim.cmd('edit ' .. target)
            return
        end
    end

    vim.notify('No matching header/source found', vim.log.levels.WARN)
end

-- Compile command for make-based projects
function M.make_build(target)
    target = target or ''
    local cmd = target ~= '' and ('make ' .. target) or 'make'
    vim.cmd('botright split | term ' .. cmd)
end

-- Set common C/C++ buffer options
function M.set_buffer_opts()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 100
    vim.opt_local.colorcolumn = '100'
    vim.opt_local.commentstring = '// %s'
    vim.opt_local.makeprg = vim.bo.filetype == 'cpp' and 'g++ -std=c++20 -Wall -Wextra %:t -o %:t:r' or 'gcc -std=c11 -Wall -Wextra %:t -o %:t:r'
end

return M
