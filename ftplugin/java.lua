-- Java-specific configuration and keymaps

local opts = { buffer = true, noremap = true, silent = true }

-- Helper function to run command in a terminal split
local function run_in_terminal(cmd, desc)
  return function()
    vim.cmd("botright split")
    vim.cmd("term " .. cmd)
  end
end

-- Build and run commands (output shown in terminal split at bottom)
vim.keymap.set("n", "<leader>jmb", run_in_terminal("mvn clean compile", "Build"), vim.tbl_extend("force", opts, { desc = "Maven: Build" }))
vim.keymap.set("n", "<leader>jmr", run_in_terminal("mvn clean compile exec:java", "Run"), vim.tbl_extend("force", opts, { desc = "Maven: Run" }))
vim.keymap.set("n", "<leader>jmt", run_in_terminal("mvn clean test", "Test"), vim.tbl_extend("force", opts, { desc = "Maven: Test" }))
vim.keymap.set("n", "<leader>jmi", run_in_terminal("mvn clean install", "Install"), vim.tbl_extend("force", opts, { desc = "Maven: Install" }))

-- Quick compile without running
vim.keymap.set("n", "<leader>jmc", run_in_terminal("mvn compile", "Compile"), vim.tbl_extend("force", opts, { desc = "Maven: Compile" }))

-- Gradle commands (auto-detects gradlew or uses system gradle)
local function get_gradle_cmd()
  local root = vim.fn.getcwd()
  if vim.fn.filereadable(root .. "/gradlew") == 1 then
    return "./gradlew"
  end
  return "gradle"
end

local gradle = get_gradle_cmd()
vim.keymap.set("n", "<leader>jgb", run_in_terminal(gradle .. " build", "Build"), vim.tbl_extend("force", opts, { desc = "Gradle: Build" }))
vim.keymap.set("n", "<leader>jgr", run_in_terminal(gradle .. " run", "Run"), vim.tbl_extend("force", opts, { desc = "Gradle: Run" }))
vim.keymap.set("n", "<leader>jgt", run_in_terminal(gradle .. " test", "Test"), vim.tbl_extend("force", opts, { desc = "Gradle: Test" }))
vim.keymap.set("n", "<leader>jgi", run_in_terminal(gradle .. " clean build", "Install"), vim.tbl_extend("force", opts, { desc = "Gradle: Clean Build" }))
vim.keymap.set("n", "<leader>jgc", run_in_terminal(gradle .. " compileJava", "Compile"), vim.tbl_extend("force", opts, { desc = "Gradle: Compile" }))

-- Open interactive terminal
vim.keymap.set("n", "<leader>jsh", "<cmd>botright split | term<CR>", vim.tbl_extend("force", opts, { desc = "Open shell" }))

-- Close terminal (press 'q' or use this keymap inside terminal)
vim.keymap.set("n", "<leader>jq", "<cmd>bdelete!<CR>", vim.tbl_extend("force", opts, { desc = "Close terminal" }))

-- Compile, Run, and Delete class file for current Java class with Lombok support
vim.keymap.set('n', '<leader>jj', function()
  local file = vim.api.nvim_buf_get_name(0)
  local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
  local package = nil
  for _, l in ipairs(lines) do
    local pkg = l:match('^%s*package%s+([%w%.]+)%s*;')
    if pkg then package = pkg break end
  end
  local class = vim.fn.fnamemodify(file, ':t:r')
  local root = vim.fn.getcwd()
  local srcdir = root .. "/src/main/java"
  local fqcn = class
  if package then fqcn = package .. "." .. class end
  -- Find lombok jar in local maven repo
  local lombok_jar = vim.fn.glob(os.getenv("HOME") .. "/.m2/repository/org/projectlombok/lombok/*/lombok-*.jar")
  local cp = srcdir
  if lombok_jar ~= "" then
    cp = string.format('%s:%s', srcdir, lombok_jar)
  end
  -- Compute the class file path
  local classfile = class .. ".class"
  local classfile_path = srcdir .. "/" .. (package and package:gsub('%.','/').."/" or "") .. classfile
  local cmd = string.format('javac -proc:full -parameters -cp "%s" "%s" && cd "%s" && java -cp "%s" %s; rm -f "%s"', cp, file, srcdir, cp, fqcn, classfile_path)
  vim.cmd('botright split | term ' .. cmd)
end, { desc = 'Compile, Run, and Delete class file (with Lombok support)', buffer = true })

-- Show diagnostics in a floating window when cursor is on a squiggly line
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics under cursor', buffer = true })
