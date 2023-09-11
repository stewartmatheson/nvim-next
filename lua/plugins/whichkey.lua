return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    local wk = require('which-key')
    wk.setup({})
    wk.register({
      ["<leader>"] = {
        name = "IDE",
        i = { ':SymbolsOutline<CR>:NvimTreeToggle<CR>', 'Toggle IDE' }
      }
    })
  end
}
