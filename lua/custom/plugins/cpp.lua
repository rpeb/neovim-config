-- C/C++ IDE features: cmake-tools, clang-format, header switching, project management

return {
  -- CMake integration (configure/build/test/run from within nvim)
  {
    'Civitasv/cmake-tools.nvim',
    ft = { 'c', 'cpp', 'cmake' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      cmake_build_directory = 'build',
      cmake_build_directory_in_source = false,
      cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON' },
      cmake_soft_link_compile_commands = true,
      cmake_compile_build_type = 'Debug',
      cmake_kits = {},
      cmake_variants = {},
      cmake_variant = nil,
      cmake_build_args = {},
      cmake_test_args = {},
      cmake_launch_args = {},
      cmake_executor = {
        name = 'terminal',
        opts = {
          show_output = true,
          terminal_focus = false,
          split_direction = 'horizontal',
          split_size = 0.3,
          single_terminal_per_instance = false,
          close_on_exit = true,
        },
      },
      cmake_runner = {
        name = 'terminal',
        opts = {
          show_output = true,
          focus = true,
          split_direction = 'vertical',
          split_size = 80,
          start_insert = true,
          single_terminal_per_instance = false,
          close_on_exit = false,
        },
      },
      cmake_notifications = {
        runner = { enabled = true },
        executor = { enabled = true },
        spinner = { enabled = true },
      },
      cmake_virtual_text_support = true,
    },
    keys = {
      { '<leader>cc', '<cmd>CMakeGenerate<cr>', desc = '[C]Make [C]onfigure', ft = { 'c', 'cpp', 'cmake' } },
      {
        '<leader>cb',
        function()
          local build_dir = vim.fn.getcwd() .. '/build'
          vim.cmd 'botright 10new'
          local buf = vim.api.nvim_get_current_buf()
          local win = vim.api.nvim_get_current_win()
          vim.fn.termopen({ 'bash', '-c', 'cmake -B ' .. build_dir .. ' && cmake --build ' .. build_dir }, {
            on_exit = function(_, code)
              vim.schedule(function()
                if code == 0 and vim.api.nvim_win_is_valid(win) then
                  vim.api.nvim_win_close(win, true)
                end
              end)
            end,
          })
          vim.cmd 'startinsert'
        end,
        desc = '[C]Make [B]uild',
        ft = { 'c', 'cpp', 'cmake' },
      },
      { '<leader>cB', '<cmd>CMakeBuild!<cr>', desc = '[C]Make [B]uild (clean)', ft = { 'c', 'cpp', 'cmake' } },
      { '<leader>ct', '<cmd>CMakeRunTest<cr>', desc = '[C]Make Run [T]est', ft = { 'c', 'cpp', 'cmake' } },
      { '<leader>cR', '<cmd>CMakeRun<cr>', desc = '[C]Make [R]un', ft = { 'c', 'cpp', 'cmake' } },
      { '<leader>cS', '<cmd>CMakeStopExecutor<cr>', desc = '[C]Make [S]top', ft = { 'c', 'cpp', 'cmake' } },
      { '<leader>cC', '<cmd>CMakeClean<cr>', desc = '[C]Make [C]lean', ft = { 'c', 'cpp', 'cmake' } },
      { '<leader>cK', '<cmd>CMakeSelectKit<cr>', desc = '[C]Make Select [K]it', ft = { 'c', 'cpp', 'cmake' } },
      { '<leader>cV', '<cmd>CMakeSelectBuildType<cr>', desc = '[C]Make Select Build T[y]pe', ft = { 'c', 'cpp', 'cmake' } },
      { '<leader>cA', '<cmd>CMakeLaunchArgs<cr>', desc = '[C]Make Launch [A]rgs', ft = { 'c', 'cpp', 'cmake' } },
      { '<leader>cG', '<cmd>CMakeOpenCache<cr>', desc = '[C]Make Open Build [G]enerator', ft = { 'c', 'cpp', 'cmake' } },
      { '<leader>cO', '<cmd>CMakeCloseExecutor<cr>', desc = '[C]Make Cl[o]se Build Generator', ft = { 'c', 'cpp', 'cmake' } },
    },
  },

  -- clang-format integration via conform
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        cmake = { 'clang_format' },
        h = { 'clang_format' },
        hpp = { 'clang_format' },
      },
    },
  },

  -- Switch between .c/.h and .cpp/.hpp
  {
    'nvim-telescope/telescope.nvim',
    optional = true,
    keys = {
      { '<leader>ch', '<cmd>Telescope cmake_tools info<cr>', desc = '[C]Make [H]eader info', ft = { 'c', 'cpp' } },
    },
  },
}
