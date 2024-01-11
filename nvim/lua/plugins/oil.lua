return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = {},
  config = function()
    require("oil").setup({
      float = {
        padding = 17
      },
      default_file_explorer = true,
    })
  end,
  keys = {
    {
      mode = 'n',
      '<C-n>',
      function()
        require('oil').toggle_float()
      end,
      desc = 'Oil - parent directory'
    },
    {
      mode = 'n',
      '<C-m>',
      function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local current_dir = buf_name:gsub('/[^/]+$', '')
        require('oil').toggle_float(current_dir)
      end,
      desc = 'Oil - current directory'
    },
    {
      mode = 'n',
      '<leader>pv',
      function()
        require('oil').open()
      end,
      desc = 'Oil - cwd'
    }
  }
}
