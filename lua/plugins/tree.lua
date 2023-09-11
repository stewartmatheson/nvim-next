return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup {}

    local wk = require('which-key')
    wk.register({
      ["<leader>"] = {
        name = "Tree",
        e = { ':NvimTreeToggle<CR>', 'Toggle Tree' }
      }
    })
  end
}
