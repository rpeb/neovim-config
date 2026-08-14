-- Smooth scrolling for C-u, C-d, C-b, C-f, zt, zz, zb, etc.

return {
    { 'karb94/neoscroll.nvim', event = 'BufReadPost', opts = {} },
}
