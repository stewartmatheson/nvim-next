return {
  "nvim-lualine/lualine.nvim",
  name = "lualine",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('lualine').setup({
      sections = {
        lualine_c = {}
      }
    })
  end
}

