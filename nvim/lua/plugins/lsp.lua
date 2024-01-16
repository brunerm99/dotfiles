return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'dev-v3',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  -- LSP manager
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        })
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        -- lsp_zero.default_keymaps({buffer = bufnr, preserve_mappings = false })
        local opts = {buffer = bufnr, remap = false}
      end)

      lsp_zero.format_on_save({
        servers = {
          ['rust_analyzer'] = {'rust'},
          ['black'] = {'python'},
        }
      })

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          pattern = { "*.py" },
          desc = "Auto-format Python files after saving",
          callback = function()
              local fileName = vim.api.nvim_buf_get_name(0)
              vim.cmd(":silent !black" .. fileName)
          end,
          -- group = autocmd_group,
      })

      require('mason-lspconfig').setup({
        ensure_installed = {
            'html',
            'pyright',
            'rust_analyzer',
            'sqlls',
            'stylelint_lsp',
            sumneko_lua = {
              Lua = {
                diagnostics = { globals = { 'vim' } },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
              },
            },
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        }
      })
    end
  },
}
