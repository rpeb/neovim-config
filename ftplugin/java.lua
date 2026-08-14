-- ftplugin/java.lua — runs every time a Java file is opened
-- Provides: JDTLS startup, all Java keybinds, build system integration, formatting

local jdtls = require 'jdtls'

-- ── Indentation ──────────────────────────────────────────────────────
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
vim.bo.textwidth = 100

-- ── Root detection ───────────────────────────────────────────────────
-- Skip setup for JDTLS virtual buffers (decompiled class files)
if vim.bo.filetype == 'java' and vim.fn.expand('%:p'):match '^jdt://' then
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
    return
end

local root_markers = { 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git', 'mvnw', 'gradlew', 'settings.gradle', 'settings.gradle.kts' }
local root_dir = jdtls.setup.find_root(root_markers)
if not root_dir or root_dir == '' then root_dir = vim.fn.expand '%:p:h' end

-- ── Detect build system ──────────────────────────────────────────────
local function file_exists(path) return vim.uv.fs_stat(path) ~= nil end

local is_maven = file_exists(root_dir .. '/pom.xml') or file_exists(root_dir .. '/mvnw')
local is_gradle = file_exists(root_dir .. '/build.gradle') or file_exists(root_dir .. '/build.gradle.kts') or file_exists(root_dir .. '/gradlew')

local build = {
    is_maven = is_maven,
    is_gradle = is_gradle,
    mvn = is_maven and (file_exists(root_dir .. '/mvnw') and './mvnw' or 'mvn') or nil,
    gradle = is_gradle and (file_exists(root_dir .. '/gradlew') and './gradlew' or 'gradle') or nil,
}

-- ── Formatter XML resolution ─────────────────────────────────────────
-- Priority: project .java-format.xml > global java-formatter.xml > nil (JDTLS default)
local function resolve_formatter()
    local project_fmt = root_dir .. '/.java-format.xml'
    if file_exists(project_fmt) then return 'file://' .. project_fmt end

    local global_fmt = vim.fn.stdpath 'config' .. '/java-formatter.xml'
    if file_exists(global_fmt) then return 'file://' .. global_fmt end

    return nil
end

local formatter_url = resolve_formatter()

-- ── Workspace ────────────────────────────────────────────────────────
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath 'cache' .. '/jdtls-workspace/' .. project_name

-- ── Capabilities ─────────────────────────────────────────────────────
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, 'blink.cmp')
if ok and blink.get_lsp_capabilities then capabilities = blink.get_lsp_capabilities() end

-- ── Run command in terminal ──────────────────────────────────────────
local term_buf = nil
local auto_close_on_success = false

local function run_in_term(cmd, opts)
    opts = opts or {}
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        vim.api.nvim_buf_delete(term_buf, { force = true })
        term_buf = nil
    end
    auto_close_on_success = opts.auto_close or false
    local shell_cmd = 'cd ' .. vim.fn.fnameescape(root_dir) .. ' && ' .. cmd
    vim.cmd('vsplit | term bash -lc ' .. vim.fn.shellescape(shell_cmd))
    term_buf = vim.api.nvim_get_current_buf()
    vim.cmd 'wincmd p'
end

vim.api.nvim_create_autocmd('TermClose', {
    callback = function(ev)
        if not auto_close_on_success then return end
        local success = vim.v.event.status == 0
        auto_close_on_success = false
        if success and vim.api.nvim_buf_is_valid(ev.buf) then vim.api.nvim_buf_delete(ev.buf, { force = true }) end
    end,
})

local function run_build(cmd)
    return function()
        vim.cmd 'write'
        run_in_term(cmd, { auto_close = true })
    end
end

-- ── Detect main class (reads actual package declaration) ──────────────
local function find_main_class()
    local file = vim.fn.expand '%:p'
    local lines = vim.fn.readfile(file)
    local pkg = nil
    local class_name = vim.fn.expand '%:t:r'
    local has_main = false

    for _, line in ipairs(lines) do
        if not pkg then pkg = line:match '^%s*package%s+([%w%.]+)%s*;' end
        if line:match 'public%s+static%s+void%s+main%s*%(' then has_main = true end
    end

    if has_main and pkg then return pkg .. '.' .. class_name end
    if has_main then return class_name end
    return nil
end

-- ── Java file run command ────────────────────────────────────────────
local function run_java_file()
    vim.cmd 'write'
    local main_class = find_main_class()
    if main_class then
        -- Maven/Gradle project: use build system runner
        if build.is_maven then
            run_in_term(build.mvn .. ' compile -q exec:java -Dexec.mainClass=' .. main_class .. ' -Dexec.classpathScope=compile')
        elseif build.is_gradle then
            run_in_term(build.gradle .. ' run --quiet')
        else
            -- Standalone: compile and run
            local dir = vim.fn.expand '%:p:h'
            local out = vim.fn.stdpath 'cache' .. '/java-out'
            vim.fn.mkdir(out, 'p')
            run_in_term('javac -d ' .. out .. ' ' .. vim.fn.expand '%:p' .. ' && java -cp ' .. out .. ' ' .. main_class)
        end
    else
        -- No main method — just compile
        if build.is_maven then
            run_in_term(build.mvn .. ' compile')
        elseif build.is_gradle then
            run_in_term(build.gradle .. ' compileJava')
        else
            local out = vim.fn.stdpath 'cache' .. '/java-out'
            vim.fn.mkdir(out, 'p')
            run_in_term('javac -d ' .. out .. ' ' .. vim.fn.expand '%:p')
        end
    end
end

-- ── Keybinds ─────────────────────────────────────────────────────────
local function set_key(lhs, rhs, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = true, silent = true })
end

set_key('K', vim.lsp.buf.hover, 'Hover documentation')

-- Imports
set_key('<leader>jo', jdtls.organize_imports, 'Organize imports')
set_key(
    '<leader>jO',
    function() vim.lsp.buf.code_action { context = { diagnostics = {}, only = { 'source.organizeImports' } } } end,
    'Organize imports (source action)'
)

-- Refactoring
set_key('<leader>jn', vim.lsp.buf.rename, 'Rename symbol')
set_key('<leader>jev', jdtls.extract_variable, 'Extract variable')
set_key('<leader>jem', function() jdtls.extract_method(true) end, 'Extract method', 'v')
set_key('<leader>jec', jdtls.extract_constant, 'Extract constant')
set_key(
    '<leader>jeF',
    function()
        vim.lsp.buf.code_action {
            context = { diagnostics = {}, only = { 'refactor.extract.field' } },
            apply = true,
        }
    end,
    'Extract field'
)
set_key('<leader>ji', vim.lsp.buf.code_action, 'Inline')

-- Navigation
set_key('<leader>jh', vim.lsp.buf.typehierarchy, 'Type hierarchy')
set_key('<leader>jH', vim.lsp.buf.incoming_calls, 'Call hierarchy (incoming)')
set_key('<leader>ju', vim.lsp.buf.definition, 'Go to definition')
set_key('<leader>jr', vim.lsp.buf.references, 'Find references')
set_key('<leader>jj', vim.lsp.buf.implementation, 'Go to implementation')

-- Code intelligence
set_key('<leader>ja', vim.lsp.buf.code_action, 'Code actions')
set_key('<leader>jd', function() vim.lsp.buf.hover() end, 'Quick documentation')
set_key('<leader>jp', vim.lsp.buf.signature_help, 'Signature help')

-- Code generation (via JDTLS source actions)
set_key('<leader>jg', function()
    vim.ui.select({ 'constructor', 'getter', 'setter', 'toString', 'equals', 'hashCode' }, {
        prompt = 'Generate:',
    }, function(choice)
        if not choice then return end
        local actions = {
            constructor = 'source.generateConstructor',
            getter = 'source.generateGettersAndSetters',
            setter = 'source.generateGettersAndSetters',
            toString = 'source.generateToString',
            equals = 'source.generateEqualsUsingInstanceof',
            hashCode = 'source.generateHashCodeUsingObjects',
        }
        vim.lsp.buf.code_action {
            context = { diagnostics = {}, only = { actions[choice] } },
            apply = true,
        }
    end)
end, 'Generate code')

-- Format
set_key('<leader>mf', function() vim.lsp.buf.format { async = true, name = 'jdtls' } end, 'Format with JDTLS')

-- ── Build / Run keybinds ─────────────────────────────────────────────
if build.is_maven then
    set_key('<leader>mb', run_build(build.mvn .. ' compile'), 'Maven: compile')
    set_key('<leader>mr', function()
        vim.cmd 'write'
        run_in_term(build.mvn .. ' compile -q exec:java -Dexec.classpathScope=compile')
    end, 'Maven: run')
    set_key('<leader>mc', run_build(build.mvn .. ' clean compile'), 'Maven: clean compile')
    set_key('<leader>mt', run_build(build.mvn .. ' test'), 'Maven: test')
    set_key('<leader>md', run_build(build.mvn .. ' dependency:tree'), 'Maven: dependency tree')
    set_key('<leader>mu', run_build(build.mvn .. ' versions:use-latest-versions'), 'Maven: update deps')
    set_key('<leader>ms', function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == 'terminal' then vim.api.nvim_buf_delete(buf, { force = true }) end
        end
    end, 'Stop build process')
    set_key('<leader>mx', function()
        vim.cmd 'write'
        run_in_term(build.mvn .. ' compile -q && ' .. build.mvn .. ' exec:java -Dexec.classpathScope=compile')
    end, 'Maven: build & run')
elseif build.is_gradle then
    set_key('<leader>mb', run_build(build.gradle .. ' build'), 'Gradle: build')
    set_key('<leader>mr', function()
        vim.cmd 'write'
        run_in_term(build.gradle .. ' run')
    end, 'Gradle: run')
    set_key('<leader>mc', run_build(build.gradle .. ' clean build'), 'Gradle: clean build')
    set_key('<leader>mt', run_build(build.gradle .. ' test'), 'Gradle: test')
    set_key('<leader>md', run_build(build.gradle .. ' dependencies'), 'Gradle: dependency tree')
    set_key('<leader>mu', run_build(build.gradle .. ' --refresh-dependencies'), 'Gradle: update deps')
    set_key('<leader>ms', function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == 'terminal' then vim.api.nvim_buf_delete(buf, { force = true }) end
        end
    end, 'Stop build process')
    set_key('<leader>mx', function()
        vim.cmd 'write'
        run_in_term(build.gradle .. ' run')
    end, 'Gradle: run (last)')
else
    -- Standalone Java: no build system
    set_key('<leader>mb', run_build('javac ' .. vim.fn.expand '%:p'), 'Compile current file')
    set_key('<leader>mr', run_java_file, 'Run current file')
    set_key('<leader>mc', run_build('javac ' .. vim.fn.expand '%:p'), 'Compile (clean)')
    set_key('<leader>ms', function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == 'terminal' then vim.api.nvim_buf_delete(buf, { force = true }) end
        end
    end, 'Stop process')
    set_key('<leader>mx', run_java_file, 'Run last')
end

-- Run current class (always available regardless of build system)
set_key('<leader>jc', run_java_file, 'Run current class')

-- Kill terminal
set_key('<leader>jk', function()
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        vim.api.nvim_buf_delete(term_buf, { force = true })
        term_buf = nil
    end
end, 'Kill terminal')

-- ── CodeLens ─────────────────────────────────────────────────────────
local function setup_codelens(client, bufnr)
    if not client.server_capabilities.codeLensProvider then return end
    vim.lsp.codelens.refresh { bufnr = bufnr }
    vim.api.nvim_create_autocmd('InsertLeave', {
        buffer = bufnr,
        callback = function() vim.lsp.codelens.refresh { bufnr = bufnr } end,
    })
    vim.api.nvim_create_autocmd('BufEnter', {
        buffer = bufnr,
        callback = function() vim.lsp.codelens.refresh { bufnr = bufnr } end,
    })
end

-- ── JDTLS configuration ─────────────────────────────────────────────
local config = {
    cmd = { 'jdtls', '-data', workspace_dir },
    root_dir = root_dir,
    capabilities = capabilities,
    settings = {
        java = {
            configuration = {
                updateBuildConfiguration = 'interactive',
                runtimes = {
                    { name = 'JavaSE-17', path = vim.fn.expand '$JAVA_HOME' },
                },
            },
            maven = { downloadSources = true },
            gradle = {
                downloadSources = true,
                wrapper = { enabled = true },
            },
            format = {
                enabled = true,
                settings = formatter_url and { url = formatter_url, profile = 'NvimJava' } or nil,
            },
            signatureHelp = { enabled = true },
            completion = {
                favoriteStaticMembers = {
                    'org.junit.Assert.*',
                    'org.junit.jupiter.api.Assertions.*',
                    'org.mockito.Mockito.*',
                    'org.mockito.ArgumentMatchers.*',
                    'org.assertj.core.api.Assertions.*',
                },
                importOrder = { 'java', 'javax', 'org', 'com', '' },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            referenceCodeLens = { enabled = true },
            implementationsCodeLens = { enabled = true },
        },
    },
    init_options = {
        bundles = {},
    },
    on_attach = function(client, bufnr) setup_codelens(client, bufnr) end,
}

jdtls.start_or_attach(config)
