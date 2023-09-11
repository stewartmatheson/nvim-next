local lsp_zero = {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  lazy = true,
  config = function()
    -- This is where you modify the settings for lsp-zero
    -- Note: autocompletion settings will not take effect

    require('lsp-zero.settings').preset({})
  end
}

local auto_complete = {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    { 'L3MON4D3/LuaSnip' },
  },
  config = function()
    -- Here is where you configure the autocompletion settings.
    -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
    -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

    require('lsp-zero.cmp').extend()

    -- And you can configure cmp even more, if you want to.
    local cmp = require('cmp')
    -- local cmp_action = require('lsp-zero.cmp').action()
    local lspkind = require('lspkind')

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
}

local lsp_config = {
  'neovim/nvim-lspconfig',
  cmd = 'LspInfo',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
  },
  config = function()
    -- This is where all the LSP shenanigans will live

    local lsp = require('lsp-zero')

    local on_attach = function(_, bufnr)
      -- see :help lsp-zero-keybindings
      -- to learn the available actions
      lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false })
    end

    lsp.on_attach(on_attach)

    -- (Optional) Configure lua language server for neovim
    local lsp_config = require('lspconfig')
    lsp_config.lua_ls.setup(lsp.nvim_lua_ls())
    lsp_config.lemminx.setup({ cmd = { "lemminx.exe" } })

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
  end
}

return {
  "onsails/lspkind.nvim",
  lsp_config,
  lsp_zero,
  auto_complete,
}
