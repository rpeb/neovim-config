-- Competitive Programming: quick file creation from templates
-- Snippets (cp, cp2, graph, dsu, seg, mint, bn, fori, ...) live in snippets/cpp.lua and snippets/c.lua

return {
  -- :CpNew and :CpTemplate commands
  {
    'nvim-lua/plenary.nvim',
    cmd = { 'CpNew', 'CpTemplate' },
    config = function()
      local cp_dir = vim.fn.stdpath 'data' .. '/cp'
      vim.fn.mkdir(cp_dir, 'p')

      -- Default C++ template
      local cpp_tpl = cp_dir .. '/template.cpp'
      if vim.fn.filereadable(cpp_tpl) == 0 then
        vim.fn.writefile({
          '#include <bits/stdc++.h>',
          'using namespace std;',
          'typedef long long ll;',
          '',
          'void solve() {',
          '    ',
          '}',
          '',
          'int main() {',
          '    ios_base::sync_with_stdio(false);',
          '    cin.tie(NULL);',
          '',
          '    int t = 1;',
          '    while (t--) solve();',
          '',
          '    return 0;',
          '}',
        }, cpp_tpl)
      end

      -- Default C template
      local c_tpl = cp_dir .. '/template.c'
      if vim.fn.filereadable(c_tpl) == 0 then
        vim.fn.writefile({
          '#include <stdio.h>',
          '#include <stdlib.h>',
          '#include <string.h>',
          '#include <math.h>',
          '',
          'typedef long long ll;',
          '',
          'void solve() {',
          '    ',
          '}',
          '',
          'int main() {',
          '    int t;',
          '    scanf("%d", &t);',
          '    while (t--) solve();',
          '    return 0;',
          '}',
        }, c_tpl)
      end

      vim.api.nvim_create_user_command('CpNew', function(opts)
        local filename = opts.args
        if filename == '' then
          filename = vim.fn.input 'Filename (e.g. sol.cpp): '
        end
        if filename == '' then return end
        if not filename:match '%.' then filename = filename .. '.cpp' end

        local ext = filename:match '%.(%w+)$'
        local tpl = cp_dir .. '/template.' .. ext
        if vim.fn.filereadable(tpl) == 0 then
          tpl = cp_dir .. '/template.cpp'
          if vim.fn.filereadable(tpl) == 0 then
            vim.notify('No template. Create at ' .. cp_dir, vim.log.levels.WARN)
            return
          end
        end

        vim.fn.writefile(vim.fn.readfile(tpl), filename)
        vim.cmd('edit ' .. filename)
        vim.notify('Created ' .. filename)
      end, { nargs = '?', complete = 'file' })

      vim.api.nvim_create_user_command('CpTemplate', function()
        local file = vim.api.nvim_buf_get_name(0)
        local ext = file:match '%.(%w+)$' or 'cpp'
        local tpl = cp_dir .. '/template.' .. ext
        if vim.fn.filereadable(tpl) == 0 then tpl = cp_dir .. '/template.cpp' end
        vim.cmd('edit ' .. tpl)
      end, {})
    end,
    keys = {
      { '<leader>cn', '<cmd>CpNew<cr>', desc = '[CP] [N]ew file' },
      { '<leader>cT', '<cmd>CpTemplate<cr>', desc = '[CP] Edit [T]emplate' },
    },
  },
}
