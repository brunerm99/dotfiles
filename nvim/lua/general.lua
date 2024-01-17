vim.api.nvim_command('set number')
vim.api.nvim_command('set relativenumber')
vim.api.nvim_command('set cursorline')
vim.api.nvim_command('set smartindent')
vim.api.nvim_command('set clipboard=unnamedplus')
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Auto formatting
vim.api.nvim_create_augroup("AutoFormat", {})
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.py",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !black --quiet %")
            vim.cmd("edit")
        end,
    }
)
