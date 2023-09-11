return {
  'simrat39/symbols-outline.nvim',
  config = function()
    require('symbols-outline').setup({
      keymaps = {
        close = {}
      }
    })

    local wk = require('which-key')
    wk.register({
      ["<leader>"] = {
        name = "Code Symbols",
        s = { ':SymbolsOutline<CR>', 'Toggle Outline' }
      }
    })
  end
}
