return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context'
    },
    build = ":TSUpdate",
    config = function()
      local languages = {
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
      }
      local treesitter = require('nvim-treesitter')

      treesitter.setup({
        install_dir = vim.fn.stdpath('data') .. '/treesitter-personal'
      })
      treesitter.install(languages)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
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
