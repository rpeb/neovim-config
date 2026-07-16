-- Task runner (make, npm, cargo, vscode tasks, etc.)
-- Linux kernel tasks: <leader>rr when in kernel repo

return {
  {
    'stevearc/overseer.nvim',
    cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerQuickAction', 'OverseerShell' },
    opts = {},
    keys = {
      { '<leader>or', '<cmd>OverseerRun<cr>', desc = '[O]verseer [R]un task' },
      { '<leader>oT', '<cmd>OverseerToggle<cr>', desc = '[O]verseer [T]ask list' },
      { '<leader>oS', '<cmd>OverseerShell<cr>', desc = '[O]verseer [S]hell' },
    },
    config = function(_, opts)
      require('overseer').setup(vim.tbl_deep_extend('force', opts or {}, {
        task_list = {
          keymaps = {
            a = { '<cmd>OverseerRun<cr>', desc = '[A]dd / run new task' },
          },
        },
        -- Disable built-in make: kernel Makefile is huge, make -rRpq is slow and can timeout
        disable_template_modules = { 'overseer.template.make' },
      }))

      -- Register linux kernel tasks directly (reliable, no file discovery)
      local gcc_efm = [[%f:%l:%c: %m,%f:%l: %m,%-G%%.%#]]
      require('overseer').register_template({
        name = 'linux_kernel',
        cache_key = function(opts)
          return (opts.dir or '') .. '|' .. vim.fn.getcwd()
        end,
        generator = function(gen_opts)
          -- Try multiple dirs: buffer dir, cwd (Cursor/VSCode may differ)
          local dirs_to_try = {}
          local seen = {}
          for _, d in ipairs({ gen_opts.dir, vim.fn.getcwd() }) do
            if d and d ~= '' and not seen[d] then
              seen[d] = true
              table.insert(dirs_to_try, d)
            end
          end
          local makefile = nil
          local cwd = nil
          for _, d in ipairs(dirs_to_try) do
            if d and d ~= '' then
              makefile = vim.fs.find('Makefile', { upward = true, type = 'file', path = d })[1]
              if makefile then
                cwd = vim.fs.dirname(makefile)
                break
              end
            end
          end
          -- Fallback: even without Makefile, offer make in cwd (helps Cursor/workspace)
          cwd = cwd or vim.fn.getcwd()
          if not makefile then
            return {
              {
                name = 'make',
                desc = 'Run make in ' .. cwd,
                builder = function()
                  return {
                    cmd = { 'make' },
                    cwd = cwd,
                    components = { 'on_output_quickfix', 'default' },
                  }
                end,
              },
            }
          end

          local function task(name, cmd, desc)
            return {
              name = name,
              desc = desc,
              builder = function()
                return {
                  cmd = cmd,
                  cwd = cwd,
                  components = {
                    { 'on_output_quickfix', errorformat = gcc_efm, open_on_match = true, open_on_exit = 'failure', open_height = 8 },
                    'default',
                  },
                }
              end,
            }
          end

          return {
            task('make -j$(nproc)', { 'make', '-j' .. tostring(vim.uv.os_available_parallelism() or 4) }, 'Build kernel'),
            task('make', { 'make' }, 'Build kernel (single job)'),
            task('make modules', { 'make', 'modules' }, 'Build modules only'),
            task('make clean', { 'make', 'clean' }, 'Clean build'),
            task('make mrproper', { 'make', 'mrproper' }, 'Deep clean'),
            task('make defconfig', { 'make', 'defconfig' }, 'Default config'),
            task('make menuconfig', { 'make', 'menuconfig' }, 'Config (ncurses)'),
            task('make xconfig', { 'make', 'xconfig' }, 'Config (Qt)'),
            task('make modules_install', { 'make', 'modules_install' }, 'Install modules'),
            task('make dtbs', { 'make', 'dtbs' }, 'Build device trees'),
            task('make scripts', { 'make', 'scripts' }, 'Build scripts'),
            {
              name = 'gen_compile_commands',
              desc = 'Generate compile_commands.json for clangd',
              builder = function()
                return {
                  cmd = { 'python3', 'scripts/clang-tools/gen_compile_commands.py' },
                  cwd = cwd,
                  components = {
                    { 'on_output_quickfix', errorformat = gcc_efm, open_on_match = true, open_on_exit = 'failure', open_height = 8 },
                    'default',
                  },
                }
              end,
            },
          }
        end,
      })

      vim.cmd.cnoreabbrev('OS OverseerShell')
    end,
  },
}
