local parsers = {
  "bash",
  "go",
  "javascript",
  "json",
  "lua",
  "python",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "yaml",
}

require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_highlighting", { clear = true }),
  pattern = {
    "bash",
    "go",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "lua",
    "python",
    "rust",
    "sh",
    "toml",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  callback = function(event)
    pcall(vim.treesitter.start, event.buf)
  end,
})

require("treesitter-context").setup({
  max_lines = 3,
  multiline_threshold = 1,
  separator = "─",
})
