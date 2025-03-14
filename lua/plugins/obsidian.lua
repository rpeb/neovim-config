return {
  "epwalsh/obsidian.nvim",
  --dir = "/Users/prakashdubey/Projects/github/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "ObsidianVault",
          path = "/Users/prakashdubey/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault1",
        },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      notes_subdir="inbox",
      new_notes_location = "notes_subdir",
      note_id_func = function(title)
        return title
      end,
      mappings = {},
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        tags = "",
        substitutions = {
          yesterday = function()
            return os.date("%Y-%m-%d", os.time() - 86400)
          end,
          tomorrow = function()
            return os.date("%Y-%m-%d", os.time() + 86400)
          end,
        },
      },
      log_level = vim.log.levels.DEBUG,
      ui = {
        enable = false, -- using render-markdown.nvim instead
      },
      disable_frontmatter = true
    })
  end,
}
