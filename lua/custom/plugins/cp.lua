-- Competitive Programming: templates, snippets, quick file creation
-- No external dependencies -- pure LuaSnip + user commands

return {
  -- Quick snippet expansion for CP
  {
    'L3MON4D3/LuaSnip',
    opts = function(_, opts)
      local ls = require 'luasnip'
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local c = ls.choice_node

      -- C++ CP template (classic)
      ls.add_snippets('cpp', {
        s('cp', {
          t { '#include <bits/stdc++.h>', 'using namespace std;', 'typedef long long ll;', 'typedef pair<int,int> pii;', 'typedef vector<int> vi;', '', 'void solve() {', '    ' },
          i(1),
          t { '', '}', '', 'int main() {', '    ios_base::sync_with_stdio(false);', '    cin.tie(NULL);', '', '    int t = 1;' },
          c(2, { t '', t { '    cin >> t;', '    while (t--)' } }),
          t { '    while (t--) {', '        solve();', '    }', '', '    return 0;', '}' },
        }),

        -- C++ CP template (minimal)
        s('cp2', {
          t { '#include <bits/stdc++.h>', 'using namespace std;', '', 'void solve() {', '    ' },
          i(1),
          t { '', '}', '', 'int main() {', '    int t;' },
          t { '', '    cin >> t;' },
          t { '', '    while (t--) solve();' },
          t { '', '    return 0;', '}' },
        }),

        -- Graph/BFS template
        s('graph', {
          t { 'vector<int> adj[N];', 'bool vis[N];', 'int dist[N];', '', 'void bfs(int src) {' },
          t { '', '    memset(dist, -1, sizeof(dist));' },
          t { '', '    queue<int> q;' },
          t { '', '    dist[src] = 0;' },
          t { '', '    q.push(src);' },
          t { '', '    while (!q.empty()) {' },
          t { '', '        int u = q.front(); q.pop();' },
          t { '', '        for (int v : adj[u]) {' },
          t { '', '            if (dist[v] == -1) {' },
          t { '', '                dist[v] = dist[u] + 1;' },
          t { '', '                q.push(v);', '            }', '        }', '    }', '}' },
        }),

        -- DSU template
        s('dsu', {
          t { 'struct DSU {', '    vector<int> parent, rank;', '    DSU(int n) : parent(n), rank(n, 0) {' },
          t { '', '        iota(parent.begin(), parent.end(), 0);', '    }' },
          t { '', '    int find(int x) {' },
          t { '', '        if (parent[x] != x) parent[x] = find(parent[x]);' },
          t { '', '        return parent[x];', '    }' },
          t { '', '', '    bool unite(int x, int y) {' },
          t { '', '        x = find(x); y = find(y);' },
          t { '', '        if (x == y) return false;' },
          t { '', '        if (rank[x] < rank[y]) swap(x, y);' },
          t { '', '        parent[y] = x;' },
          t { '', '        if (rank[x] == rank[y]) rank[x]++;' },
          t { '', '        return true;', '    }', '};' },
        }),

        -- Segment tree template
        s('seg', {
          t { 'const int N = 2e5 + 5;', 'll tree[4 * N], lazy[4 * N];', '', 'void push(int node, int l, int r) {' },
          t { '', '    if (lazy[node] != 0) {' },
          t { '', '        tree[node] += lazy[node];' },
          t { '', '        if (l != r) { lazy[2*node] += lazy[node]; lazy[2*node+1] += lazy[node]; }' },
          t { '', '        lazy[node] = 0;', '    }', '}' },
          t { '', '', 'void build(int node, int l, int r) {' },
          t { '', '    if (l == r) { tree[node] = 0; return; }' },
          t { '', '    int mid = (l+r)/2;' },
          t { '', '    build(2*node, l, mid); build(2*node+1, mid+1, r);' },
          t { '', '    tree[node] = tree[2*node] + tree[2*node+1];', '}' },
          t { '', '', 'void update(int node, int l, int r, int ql, int qr, ll val) {' },
          t { '', '    push(node, l, r); if (qr < l || r < ql) return;' },
          t { '', '    if (ql <= l && r <= qr) { lazy[node] += val; push(node, l, r); return; }' },
          t { '', '    int mid = (l+r)/2;' },
          t { '', '    update(2*node, l, mid, ql, qr, val); update(2*node+1, mid+1, r, ql, qr, val);' },
          t { '', '    tree[node] = tree[2*node] + tree[2*node+1];', '}' },
          t { '', '', 'll query(int node, int l, int r, int ql, int qr) {' },
          t { '', '    push(node, l, r); if (qr < l || r < ql) return 0;' },
          t { '', '    if (ql <= l && r <= qr) return tree[node];' },
          t { '', '    int mid = (l+r)/2;' },
          t { '', '    return query(2*node, l, mid, ql, qr) + query(2*node+1, mid+1, r, ql, qr);', '}' },
        }),

        -- Modular arithmetic
        s('mint', {
          t { 'const int MOD = 1e9 + 7;', '', 'll modpow(ll base, ll exp, ll mod) {' },
          t { '', '    ll result = 1;' },
          t { '', '    while (exp > 0) {' },
          t { '', '        if (exp & 1) result = result * base % mod;' },
          t { '', '        base = base * base % mod;' },
          t { '', '        exp >>= 1;', '    }' },
          t { '', '    return result;', '}' },
        }),

        -- Read input helper
        s('bn', {
          t { 'int n;' },
          t { '', 'cin >> n;' },
          t { '', 'vi a(n);' },
          t { '', 'for (auto &x : a) cin >> x;' },
        }),

        -- For loop snippet
        s('fori', {
          t { 'for (int i = 0; i < ' },
          i(1, 'n'),
          t { '; i++) {', '    ' },
          i(2),
          t { '', '}' },
        }),
      })

      -- C snippets
      ls.add_snippets('c', {
        s('cp', {
          t { '#include <stdio.h>', '#include <stdlib.h>', '#include <string.h>', '#include <math.h>', '', 'typedef long long ll;', '', 'void solve() {' },
          t { '', '    ' },
          i(1),
          t { '', '}', '', 'int main() {' },
          t { '', '    int t;' },
          t { '', '    scanf("%d", &t);' },
          t { '', '    while (t--) solve();' },
          t { '', '    return 0;', '}' },
        }),
      })
    end,
  },

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
