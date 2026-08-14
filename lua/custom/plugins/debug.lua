-- DAP plugin to debug your code (Go + Java, extendable to other languages)

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<F7>', function() require('dapui').toggle() end, desc = 'Debug: Toggle DAP UI' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Conditional Breakpoint' },
    { '<leader>E', function() require('dap').set_exception_breakpoints() end, desc = 'Debug: Exception Breakpoints' },
    { '<leader>dx', function() require('dap').terminate() end, desc = 'Debug: Terminate' },
    { '<leader>dl', function() require('dap').run_last() end, desc = 'Debug: Run Last' },
    { '<leader>dt', function() require('neotest').run.run { strategy = 'dap' } end, desc = 'Debug: Nearest Test' },
    { '<leader>dr', function() require('dapui').float_element('repl', { width = 100, height = 40, enter = true }) end, desc = 'Debug: REPL' },
    { '<leader>ds', function() require('dapui').float_element('scopes', { width = 150, height = 50, enter = true }) end, desc = 'Debug: Scopes' },
    { '<leader>df', function() require('dapui').float_element('stacks', { width = 150, height = 50, enter = true }) end, desc = 'Debug: Stacks' },
    { '<leader>db', function() require('dapui').float_element('breakpoints', { enter = true }) end, desc = 'Debug: Breakpoints' },
    { '<leader>do', function() require('dapui').toggle() end, desc = 'Debug: Toggle DAP UI' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { 'delve', 'java-debug-adapter', 'java-test', 'cppdbg' },
    }

    -- Satisfy nvim-dap-ui's internal adapter (prevents "No configuration found" error)
    dap.adapters.dapui_breakpoints = {
      type = 'server',
      port = '${port}',
    }
    dap.configurations.dapui_breakpoints = {}

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    require('dap-go').setup {
      delve = { detached = vim.fn.has 'win32' == 0 },
    }

    -- C/C++ debugging via GDB (cpptools adapter)
    dap.configurations.c = {
      {
        name = 'Launch (GDB)',
        type = 'cppdbg',
        request = 'launch',
        program = function()
          local file = vim.api.nvim_buf_get_name(0)
          local dir = vim.fn.fnamemodify(file, ':h')
          local exe = vim.fn.fnamemodify(file, ':t:r')
          return vim.fn.input('Path to executable: ', dir .. '/' .. exe, 'file')
        end,
        cwd = function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h') end,
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
          local file = vim.api.nvim_buf_get_name(0)
          local dir = vim.fn.fnamemodify(file, ':h')
          return vim.fn.input('Path to executable: ', dir .. '/', 'file')
        end,
        cwd = function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h') end,
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
          local dir = vim.fn.fnamemodify(file, ':h')
          local exe = vim.fn.fnamemodify(file, ':t:r')
          return dir .. '/' .. exe
        end,
        cwd = function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h') end,
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

    -- Java debugging: use JDTLS as the DAP host
    dap.configurations.java = {
      {
        type = 'java',
        request = 'launch',
        name = 'Debug (Current File)',
        mainClass = function()
          local file = vim.fn.expand '%:p'
          local lines = vim.fn.readfile(file)
          for _, line in ipairs(lines) do
            if line:match 'public%s+static%s+void%s+main%s*%(' then
              local name = vim.fn.expand '%:t:r'
              local pkg = vim.fn.expand '%:h':match 'java/(.+)'
              if pkg then return pkg .. '.' .. name end
              return name
            end
          end
          return vim.fn.expand '%:t:r'
        end,
        projectName = function()
          return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        end,
      },
    }
  end,
}
