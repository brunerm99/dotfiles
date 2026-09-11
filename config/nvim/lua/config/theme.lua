-- Follow the terminal appearance with the Workbench light/dark palettes.
-- Clear the previous theme's callbacks when this module is reloaded in a live session.
pcall(vim.api.nvim_del_augroup_by_name, "tokyonight_background")
vim.opt.termguicolors = true
vim.cmd.colorscheme("workbench")
