return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdateSync" },
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "xml" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
