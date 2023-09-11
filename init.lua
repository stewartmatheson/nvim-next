local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.updatetime = 100
vim.g.cursorhold_updatetime = 100
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.diagnostic.config({ virtual_text = false })

vim.keymap.set("n", "<tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-tab>", ":bprevious<CR>", { silent = true })

local filetypes = vim.api.nvim_create_augroup("FileTypes", {})
vim.api.nvim_create_autocmd(
  { "BufEnter" },
  {
    group = filetypes,
    pattern = { "*.lua", "*.cpp", "*.hpp", "*.c", "*.h" },
    callback = function()
      vim.o.expandtab = true
      vim.o.tabstop = 2
      vim.o.shiftwidth = 2
    end
  }
)

-- Function to check if a floating dialog exists and if not
-- then check for diagnostics under the cursor
local open_diagnostics = function()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end

  -- THIS IS FOR BUILTIN LSP
  vim.diagnostic.open_float(0, {
    scope = "cursor",
    focusable = false,
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "BufHidden",
      "InsertCharPre",
      "WinLeave",
    },
  })
end

-- Show diagnostics under the cursor when holding position
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = open_diagnostics,
  group = "lsp_diagnostics_hold",
})

local catppuccin_lazy = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      transparent_background = true,
    })
    vim.cmd.colorscheme "catppuccin"
  end,
}

local lua_line = {
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

local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}

local telescope = {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.2",
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup({
      pickers = {
        find_files = {
          theme = "ivy",
        },
        live_grep = {
          theme = "ivy",
        },
        help_tags = {
          theme = "ivy",
        },
        buffers = {
          theme = "ivy",
        },
        hightlights = {
          theme = "ivy",
        },
        spell_suggest = {
          theme = "ivy",
        },
        vim_options = {
          theme = "ivy",
        },
        autocommands = {
          theme = "ivy",
        },
        git_status = {
          theme = "ivy",
        },
      },
    })

    local wk = require('which-key')
    local builtin = require('telescope.builtin')

    wk.register({
      ["<leader>"] = {
        f = {
          name = "Search",
          f = { builtin.find_files, 'Find Files' },
          b = { builtin.buffers, 'Find Buffers' },
          h = { builtin.help_tags, 'Find Help Tags' },
          l = { builtin.hightlights, 'Find Highlights' },
          s = { builtin.spell_suggest, 'Find Spelling' },
          o = { builtin.vim_options, 'Find Options' },
          a = { builtin.autocommands, 'Find Autocommands' },
          g = { builtin.git_status, 'Find Chagnes' },
        }
      }
    })
  end
}

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

local whichkey = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require('which-key').setup {}
  end
}

local gitsigns = {
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup()
  end
}

local trouble = {
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

local symbols_outline = {
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

local set_winbar = function()
  local icon, color = require 'nvim-web-devicons'.get_icon_color("%f", vim.bo.filetype)
  vim.api.nvim_set_hl(0, 'WinBarFileTypeIcon', { bg = 'NONE', fg = color })
  local file_path = vim.api.nvim_eval_statusline("%F", {}).str
  local raw_line = '%#WinBarFileTypeIcon#' .. icon .. "%#ToobarLine# " .. file_path
  vim.opt_local.winbar = raw_line
end

local file_icons = {
  "nvim-tree/nvim-web-devicons",
  config = function()
    local devicons = require("nvim-web-devicons")
    devicons.setup()
    vim.api.nvim_create_autocmd(
      { "BufWinEnter" },
      {
        group = filetypes,
        pattern = "*",
        callback = function()
          local current_devicon = devicons.get_icon_by_filetype(vim.bo.filetype, {})
          if current_devicon == nil then
            vim.opt.winbar = "%F"
          else
            set_winbar()
          end
        end
      }
    )
  end
}

local blame = {
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

--[[
require("lazy").setup({
  catppuccin_lazy,
  whichkey,
  lua_line,
  treesitter,
  telescope,
  lsp_zero,
  gitsigns,
  trouble,
  "antoinemadec/FixCursorHold.nvim",
  "onsails/lspkind.nvim",
  symbols_outline,
  file_icons,
  blame
})
]]
   --

require("lazy").setup("plugins")
