-- Omarchy's LazyVim adapter; the standalone Kraken colorscheme needs no plugin.
return {
  { 'LazyVim/LazyVim',
    init = function()
      vim.opt.rtp:prepend(vim.fn.expand('~/.config/omarchy/current/theme/nvim'))
      vim.o.background = 'dark'
    end,
    opts = { colorscheme = 'rimeworks' },
  },
}
