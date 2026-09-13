local cmp = require("cmp")

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noselect",
  },
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(arguments)
      vim.snippet.expand(arguments.body)
    end,
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping(function()
      cmp.abort()
      require("config.signature").close_signature(nil, true)
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  },
  sources = {
    { name = "path", option = { trailing_slash = true } },
    { name = "nvim_lsp" },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})
