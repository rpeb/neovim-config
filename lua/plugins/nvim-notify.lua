return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      timeout = 5000, -- 1 second
    })
  end,
}
