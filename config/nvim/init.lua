vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.plugins")
require("config.theme")
require("config.treesitter")
require("config.completion")
require("config.lsp")
require("config.signature")
require("config.navigation")
require("config.format")
require("config.picker")
require("config.active_files").setup()
require("config.tree")
require("config.pairs")
