local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
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
    pattern = { "*.lua", "*.xml", "*.cpp", "*.hpp", "*.c", "*.h" },
    callback = function()
      vim.o.expandtab = true
      vim.o.tabstop = 2
      vim.o.shiftwidth = 2
    end
  }
)

local set_winbar = function()
  local icon, color = require 'nvim-web-devicons'.get_icon_color("%f", vim.bo.filetype)
  vim.api.nvim_set_hl(0, 'WinBarFileTypeIcon', { bg = 'NONE', fg = color })
  local file_path = vim.api.nvim_eval_statusline("%F", {}).str
  if icon == nil then
    vim.opt_local.winbar = "%#ToobarLine# " .. file_path
  else
    vim.opt_local.winbar = '%#WinBarFileTypeIcon#' .. icon .. "%#ToobarLine# " .. file_path
  end
end

vim.api.nvim_create_autocmd(
  { "BufWinEnter" },
  {
    group = filetypes,
    pattern = "*",
    callback = function()
      local devicons = require('nvim-web-devicons')
      local current_devicon = devicons.get_icon_by_filetype(vim.bo.filetype, {})
      if current_devicon == nil then
        vim.opt.winbar = "%F"
      else
        set_winbar()
      end
    end
  }
)

require("lazy").setup("plugins")
