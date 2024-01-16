return {
  "theprimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon"):setup()
  end,
  keys = {
    { "<C-S-H>", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon toggle quick menu", },
    { "<C-S-N>", function() require("harpoon"):list():next() end, desc = "Harpoon to next file", },
    { "<C-S-I>", function() require("harpoon"):list():prev() end, desc = "Harpoon to previous file", },
  },
}
