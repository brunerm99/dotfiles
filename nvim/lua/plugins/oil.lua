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
      '<leader>pv',
      function()
        require('oil').open()
      end,
      desc = 'Open CWD in Oil'
    }
  }
}
