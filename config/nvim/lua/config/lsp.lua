-- Set a server to true when Mason should install it, or false when the
-- executable is already supplied by the system.
local servers = {
  pyright = true,
  ruff = true,
  rust_analyzer = false,
  gopls = true,
  ts_ls = true,
  clangd = false,
  lua_ls = true,
  bashls = true,
  jsonls = true,
  yamlls = true,
  taplo = true,
}

local mason_servers = {}
for name, install_with_mason in pairs(servers) do
  if install_with_mason then
    table.insert(mason_servers, name)
  end
end

require("mason-lspconfig").setup({
  ensure_installed = mason_servers,
  automatic_enable = false,
})

-- Pyright provides richer Python hover documentation. Ruff remains attached
-- for diagnostics, code actions, and formatting.
vim.lsp.config("ruff", {
  init_options = {
    settings = {
      lint = {
        -- ManimGL intentionally exposes its API through `from manimlib import *`.
        -- Keep Ruff's other checks, but do not flag every imported Manim symbol.
        ignore = { "F403", "F405" },
      },
    },
  },
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})

vim.lsp.enable(vim.tbl_keys(servers))

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, action, description)
      vim.keymap.set("n", keys, action, {
        buffer = event.buf,
        desc = "LSP: " .. description,
      })
    end

    map("gd", vim.lsp.buf.definition, "go to definition")
    map("gi", vim.lsp.buf.implementation, "go to implementation")
    map("gr", vim.lsp.buf.references, "show references")
    map("<leader>rn", vim.lsp.buf.rename, "rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "code action")
    map("K", function()
      vim.lsp.buf.hover({
        border = "rounded",
        max_height = 30,
        max_width = 100,
      })
    end, "hover documentation")
    map("<leader>d", vim.diagnostic.open_float, "show diagnostic")
    map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "previous diagnostic")
    map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "next diagnostic")
  end,
})
