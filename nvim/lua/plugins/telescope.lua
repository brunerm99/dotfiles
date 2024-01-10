return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
	    'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            layout_strategy = 'vertical'
          },
          live_grep = {
            layout_strategy = 'vertical'
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        }
      }

      vim.keymap.set('n', '<leader>pb', ':Telescope buffers<Cr>');
      vim.keymap.set('n', '<leader>pf', ':Telescope find_files<Cr>');
      vim.keymap.set('n', '<leader>ps', ':Telescope live_grep<Cr>');
      vim.keymap.set('n', '<leader>pk', ':Telescope keymaps<Cr>');
      vim.keymap.set('n', '<leader>ph', ':Telescope help_tags<Cr>');
      vim.keymap.set('n', '<leader>u', ':Telescope undo<Cr>');
    end
  }
}
