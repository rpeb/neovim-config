local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('c', {
    -- C CP template (moved from lua/custom/plugins/cp.lua)
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
