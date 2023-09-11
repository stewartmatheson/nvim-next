local lsp_zero_config = function()
  local lsp = require('lsp-zero').preset({})


  -- (Optional) Configure lua language server for neovim
  require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

  lsp.on_attach(function(_, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({
      buffer = bufnr,
      preserve_mappings = false
    })
  end)

  lsp.setup_servers({ 'clangd', 'lua_ls' })

  lsp.format_on_save({
    servers = {
      ['lua_ls'] = { 'lua' },
      ['clangd'] = { 'cpp', 'c', 'h', 'hpp' }
    }
  })

  lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
  })

  lsp.setup()

  local cmp = require('cmp')
  local lspkind = require('lspkind')

  local bg = 'NONE'

  -- gray
  vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = bg, strikethrough = true, fg = '#808080' })
  -- blue
  vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = bg, fg = '#569CD6' })
  vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
  -- light blue
  vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = bg, fg = '#9CDCFE' })
  vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
  vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
  -- pink
  vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = bg, fg = '#C586C0' })
  vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
  -- front
  vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = bg, fg = '#D4D4D4' })
  vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
  vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

  cmp.setup({
    formatting = {
      format = lspkind.cmp_format(),
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    }
  })
end

local lsp_zero = {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' }, -- Required
    -- {'williamboman/mason.nvim'},           -- Optional
    -- {'williamboman/mason-lspconfig.nvim'}, -- Optional

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },     -- Required
    { 'hrsh7th/cmp-nvim-lsp' }, -- Required
    { 'L3MON4D3/LuaSnip' },     -- Required
  },
  config = lsp_zero_config
}

return {
  "onsails/lspkind.nvim",
  lsp_zero,
}
