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

      local builtin = require('telescope.builtin')
      local utils = require('telescope.utils')
      vim.keymap.set('n', '<leader>pb', function() builtin.buffers() end );
      vim.keymap.set('n', '<leader>pf', function() builtin.find_files() end);
      vim.keymap.set('n', '<leader>p.', function() builtin.find_files({cwd = utils.buffer_dir()}) end);
      vim.keymap.set('n', '<leader>ps', function() builtin.live_grep() end);
      vim.keymap.set('n', '<leader>pk', function() builtin.keymaps() end);
      vim.keymap.set('n', '<leader>ph', function() builtin.help_tags() end);
      vim.keymap.set('n', '<leader>u', function() builtin.help() end);
    end
  },
}
