-- C/C++ debugging with gdb + codelldb

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'jay-babu/mason-nvim-dap.nvim',
    'rcarriga/nvim-dap-ui',
  },
  opts = function(_, opts)
    opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
      'codelldb',
      'cpptools',
    })
  end,
  config = function(_, opts)
    local dap = require 'dap'

    -- C/C++ via GDB (cpptools adapter)
    dap.configurations.c = {
      {
        name = 'Launch (GDB)',
        type = 'cppdbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
        MIMode = 'gdb',
        gdbpath = 'gdb',
        setupCommands = {
          { text = '-enable-pretty-printing', ignoreFailures = true },
          { text = 'set pagination off', ignoreFailures = true },
        },
      },
      {
        name = 'Attach (GDB)',
        type = 'cppdbg',
        request = 'attach',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        MIMode = 'gdb',
        gdbpath = 'gdb',
        setupCommands = {
          { text = '-enable-pretty-printing', ignoreFailures = true },
          { text = 'set pagination off', ignoreFailures = true },
        },
      },
      {
        name = 'Launch (GDB, current file)',
        type = 'cppdbg',
        request = 'launch',
        program = function()
          local file = vim.api.nvim_buf_get_name(0)
          local exe = vim.fn.fnamemodify(file, ':t:r')
          return vim.fn.getcwd() .. '/build/' .. exe
        end,
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
        MIMode = 'gdb',
        gdbpath = 'gdb',
        setupCommands = {
          { text = '-enable-pretty-printing', ignoreFailures = true },
          { text = 'set pagination off', ignoreFailures = true },
        },
      },
      {
        name = 'Debug with arguments',
        type = 'cppdbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = function()
          local input = vim.fn.input('Arguments: ')
          return vim.split(input, ' ', { trimempty = true })
        end,
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
        MIMode = 'gdb',
        gdbpath = 'gdb',
        setupCommands = {
          { text = '-enable-pretty-printing', ignoreFailures = true },
          { text = 'set pagination off', ignoreFailures = true },
        },
      },
    }
    dap.configurations.cpp = dap.configurations.c

    -- C/C++ via LLDB (codelldb adapter) - better STL inspection
    dap.configurations.cpp_lldb = {
      {
        name = 'Launch (LLDB)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        environment = {},
      },
      {
        name = 'Attach (LLDB)',
        type = 'codelldb',
        request = 'attach',
        pid = function()
          return tonumber(vim.fn.input 'PID: ')
        end,
        cwd = '${workspaceFolder}',
      },
      {
        name = 'Launch (LLDB, current file)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local file = vim.api.nvim_buf_get_name(0)
          local exe = vim.fn.fnamemodify(file, ':t:r')
          return vim.fn.getcwd() .. '/build/' .. exe
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }
    -- Share cpp_lldb for cpp if user wants to switch
    -- Default cpp uses cppdbg (gdb). To switch, change dap.configurations.cpp
    -- to dap.configurations.cpp_lldb in an autocmd or keymap.

    -- CMake debug helper: auto-detect build directory
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'c', 'cpp' },
      group = vim.api.nvim_create_augroup('dap-cpp-project-detect', { clear = true }),
      callback = function(args)
        -- Find build directory (cmake-tools default or common patterns)
        local build_dir = nil
        local patterns = { 'build', 'build/debug', 'build/Debug', 'out', 'cmake-build-debug' }
        for _, p in ipairs(patterns) do
          if vim.fn.isdirectory(vim.fn.getcwd() .. '/' .. p) == 1 then
            build_dir = vim.fn.getcwd() .. '/' .. p
            break
          end
        end

        -- Update CWD for debug configurations based on project type
        if build_dir then
          -- Auto-set program path hint in DAP UI
          vim.b.dap_program_dir = build_dir
        end
      end,
    })
  end,
  keys = {
    { '<leader>dc', function() require('dap').continue() end, desc = '[D]ebug [C]ontinue' },
    { '<leader>dl', function() require('dap').step_into() end, desc = '[D]ebug Step Into' },
    { '<leader>dj', function() require('dap').step_over() end, desc = '[D]ebug Step Over' },
    { '<leader>dk', function() require('dap').step_out() end, desc = '[D]ebug Step Out' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = '[D]ebug Toggle [B]reakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Condition: ') end, desc = '[D]ebug Conditional Breakpoint' },
    { '<leader>dL', function() require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log message: ') end, desc = '[D]ebug [L]ogpoint' },
    { '<leader>dr', function() require('dap').repl.toggle() end, desc = '[D]ebug [R]EPL' },
    { '<leader>dU', function() require('dapui').toggle() end, desc = '[D]ebug [U]I Toggle' },
    { '<leader>dx', function() require('dap').terminate() end, desc = '[D]ebug Terminate' },
    { '<leader>dp', function() require('dap').pause() end, desc = '[D]ebug [P]ause' },
    { '<leader>dt', function() require('dap').restart() end, desc = '[D]ebug [R]estart' },
    { '<leader>dh', function()
      local widgets = require 'dap.ui.widgets'
      widgets.hover()
    end, desc = '[D]ebug [H]over' },
    { '<leader>ds', function()
      local widgets = require 'dap.ui.widgets'
      widgets.sidebar(widgets.scopes)
    end, desc = '[D]ebug [S]copes' },
    { '<leader>df', function()
      local widgets = require 'dap.ui.widgets'
      widgets.sidebar(widgets.frames)
    end, desc = '[D]ebug [F]rames' },
    { '<leader>di', function() require('dap.ui').float_element('repl', { enter = true }) end, desc = '[D]ebug [I]nspect (REPL)' },
    { '<leader>de', function() require('dap').set_exception_breakpoints() end, desc = '[D]ebug [E]xception breakpoints' },
    { '<leader>dR', function() require('dap').run_last() end, desc = '[D]ebug Run [R]eplay' },
    { '<leader>dG', function()
      local dap = require 'dap'
      -- Switch between gdb and lldb for cpp
      if dap.configurations.cpp == dap.configurations.cpp_lldb then
        dap.configurations.cpp = dap.configurations.c
        vim.notify('Switched to GDB', vim.log.levels.INFO)
      else
        dap.configurations.cpp = dap.configurations.cpp_lldb
        vim.notify('Switched to LLDB (codelldb)', vim.log.levels.INFO)
      end
    end, desc = '[D]ebug Switch [G]db/Lldb' },
  },
}
