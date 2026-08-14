return {
    'madskjeldgaard/cppman.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    keys = {
        { '<leader>cpm', function() require('cppman').input() end, desc = '[C++] [M]an (cppman)' },
        { '<leader>cpM', function() require('cppman').open_cppman_for(vim.fn.expand '<cword>') end, desc = '[C++] [M]an for word under cursor' },
    },
    config = function() require('cppman').setup() end,
}
