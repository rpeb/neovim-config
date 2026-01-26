return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      timeout = 1000, -- 1 second
    })
  end,
}
