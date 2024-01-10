return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context'
    },
    build = ":TSUpdate",
    config = function()
      local ts = require 'nvim-treesitter.configs'
      ts.setup({
        ensure_installed = {
          'comment',
          'diff',
          'gitignore',
          'html',
          'json',
          'markdown',
          'markdown_inline',
          'lua',
          'python',
          'rust',
          'sql',
          'toml',
          'vimdoc'
        },
        autotag = {
          enable = true
        },
        highlight = {
          enable = true,
        }
      })
    end
  },
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim')
          .create_pre_hook(),
      }
    end
  }
}
