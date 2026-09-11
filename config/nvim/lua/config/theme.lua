-- Follow the terminal appearance with the Workbench light/dark palettes.
-- Clear the previous theme's callbacks when this module is reloaded in a live session.
pcall(vim.api.nvim_del_augroup_by_name, "tokyonight_background")
vim.opt.termguicolors = true
-- Keep the cursor visible in every mode and use the theme highlight in the TUI.
vim.opt.guicursor = "a:block-blinkon0-Cursor"
vim.cmd.colorscheme("workbench")
