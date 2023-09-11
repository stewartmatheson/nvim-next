
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    auto_open = false,
    width = 30,
    position = 'bottom'
  },
  config = function()
    local wk = require('which-key')
    wk.register({
      ["<leader>"] = {
        name = "Trouble",
        t = { ':TroubleToggle<CR>', 'Toggle Trouble' }
      }
    })
  end
}
