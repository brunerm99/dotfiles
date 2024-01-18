return {
  {
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup()
      require('which-key').register({
        p = {
          name = "Project",
          f = { ":Telescope find_files<Cr>", "Find File" },
          s = { ":Telescope live_grep<Cr>", "Find String" },
          g = { ":Telescope git_files<Cr>", "Find git files" },
          k = { ":Telescope keymaps<Cr>", "Find Keymap" },
          h = { ":Telescope help_tags<Cr>", "Find Help" },
          a = { function() require("harpoon"):list():append() end, "Harpoon file" },
          l = { function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Harpoon quick menu", },
        },
        l = {
          name = "LSP",
          r = { function() vim.lsp.buf.rename() end, "Rename symbol" },
          o = { ":PyrightOrganizeImports<Cr>", "Python organize imports" },
          d = { function() require('telescope.builtin').diagnostics({opts = {bufnr = 0}}) end, "Show current buffer diagnostics" },
          D = { function() require('telescope.builtin').diagnostics() end, "Show all diagnostics" },
        },
        -- h = {
        --   name = "harpoon",
        --   { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "harpoon to file 1", },
        --   { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "harpoon to file 2", },
        --   { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "harpoon to file 3", },
        --   { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "harpoon to file 4", },
        --   { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "harpoon to file 5", },
        -- }
        w = {
          name = "Window",
          v = { ":vsplit<Cr>", "Vertical split current" },
          c = { ":close<Cr>", "Close current window" },
        }
      }, { prefix = "<leader>" })
    end
  },
}
