local function next_diagnostic()
  vim.diagnostic.jump({ count = 1, float = true })
end

local function previous_diagnostic()
  vim.diagnostic.jump({ count = -1, float = true })
end

local function organize_imports()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports" },
      diagnostics = {},
    },
  })
end

return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      local function jump_snippet(direction)
        return cmp.mapping(function(fallback)
          if luasnip.jumpable(direction) then
            luasnip.jump(direction)
          else
            fallback()
          end
        end, { "i", "s" })
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = jump_snippet(1),
          ["<C-b>"] = jump_snippet(-1),
        }),
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              logLevel = "Error",
              typeCheckingMode = "none",
              disableOrganizeImports = false,
            },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          },
        },
      })
    end,
    keys = {
      { "]d", next_diagnostic, desc = "Go to next diagnostic" },
      { "[d", previous_diagnostic, desc = "Go to previous diagnostic" },
      { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
      { "gy", vim.lsp.buf.type_definition, desc = "Go to type definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
      { "ga", vim.lsp.buf.code_action, desc = "Show code action" },
      { "gr", vim.lsp.buf.references, desc = "Show references" },
      { "lo", organize_imports, desc = "Organize imports" },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "pyright" },
      automatic_enable = { "pyright", "lua_ls" },
    },
  },
}
