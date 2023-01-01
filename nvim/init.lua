local g = vim.g
local o = vim.o
local wo = vim.wo
local bo = vim.bo
local opt = vim.opt

o.swapfile = true
o.dir = '/tmp'
o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.showmode = false

wo.number = true
wo.relativenumber = true
wo.wrap = true

bo.expandtab = true
bo.tabstop = 4
bo.shiftwidth = 4

opt.clipboard = 'unnamedplus'

-- theme
require('monokai').setup()

-- bottom info line
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- git signs
require('gitsigns').setup()

-- syntax highlighting 
require('nvim-treesitter').setup {
    ensure_installed = {
        "python", "bash", "c", "lua"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}

-- packages
return require('packer').startup(function(use)
    -- package manager
    use 'wbthomason/packer.nvim'

    -- commenting
    use 'tpope/vim-commentary'

    -- bottom bar
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

    -- theme
    use 'tanvirtin/monokai.nvim'

    -- git signs
    use 'lewis6991/gitsigns.nvim'

    -- syntax highlighting
    use 'nvim-treesitter/nvim-treesitter'
end)
