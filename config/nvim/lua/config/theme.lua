-- Follow the terminal appearance with the Workbench light/dark palettes.
-- Clear the previous theme's callbacks when this module is reloaded in a live session.
pcall(vim.api.nvim_del_augroup_by_name, "tokyonight_background")
vim.opt.termguicolors = true
-- Keep modal cursor shapes and use the high-contrast theme highlight in the TUI.
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block,a:blinkon0-Cursor"
vim.cmd.colorscheme("workbench")
