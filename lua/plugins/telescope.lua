-- TODO : Figure out how to lazy load this

return {
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
          w = { builtin.live_grep, 'Live Grep' },
        }
      }
    })
  end
}
