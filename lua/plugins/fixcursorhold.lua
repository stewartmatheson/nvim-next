return {
  "antoinemadec/FixCursorHold.nvim",
  config = function()
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
  end
}
