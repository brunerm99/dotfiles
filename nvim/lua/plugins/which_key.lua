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
          -- v = { ":Ex<Cr>", "Project explore" },
        },
        u = { ":Telescope undo<Cr>", "Undo tree" },
      }, { prefix = "<leader>" })
    end
  },
}
