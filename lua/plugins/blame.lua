return {
  "FabijanZulj/blame.nvim",
  config = function()
    local wk = require('which-key')
    wk.register({
      ["<leader>"] = {
        name = "Git",
        g = { ':ToggleBlame<CR>', 'Toggle Blame' }
      }
    })
  end
}
