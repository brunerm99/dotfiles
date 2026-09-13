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

vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Pyright provides richer Python hover documentation. Ruff remains attached
-- for diagnostics, code actions, and formatting.
vim.lsp.config("pyright", {
  before_init = function(_, config)
    local python = config.settings.python
    if python.pythonPath then
      return
    end

    local environments = {}
    for _, variable in ipairs({ "VIRTUAL_ENV", "CONDA_PREFIX" }) do
      if vim.env[variable] then
        table.insert(environments, vim.env[variable])
      end
    end
    if config.root_dir then
      -- These projects also keep a separate Manim Community .venv.
      for _, name in ipairs({ ".manimgl-local", ".manimgl", ".venv", "venv" }) do
        table.insert(environments, vim.fs.joinpath(config.root_dir, name))
      end
    end

    for _, environment in ipairs(environments) do
      local executable = vim.fs.joinpath(environment, "bin", "python")
      if vim.fn.executable(executable) == 1 then
        python.pythonPath = executable
        return
      end
    end
  end,
  settings = {
    python = {
      analysis = {
        -- Large projects can contain several virtual environments. Resolve
        -- imports from the configured environment without indexing all of
        -- their third-party packages at startup.
        indexing = false,
      },
    },
  },
})

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
    local map = function(keys, action, description, options)
      vim.keymap.set("n", keys, action, vim.tbl_extend("force", {
        buffer = event.buf,
        desc = "LSP: " .. description,
      }, options or {}))
    end

    map("gd", vim.lsp.buf.definition, "go to definition")
    map("gi", vim.lsp.buf.implementation, "go to implementation")
    map("gr", function()
      require("fzf-lua").lsp_references()
    end, "show references", { nowait = true })
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
