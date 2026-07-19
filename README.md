# MacBook dotfiles

Personal configuration for the `machine/macbook` branch:

- Fish and Zsh
- Git
- Ghostty
- Vim and Neovim
- VS Code user settings and keybindings
- Zellij

Run `./link.sh` from this checkout. Existing files with different contents are
copied to `${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/` before they
are replaced with symlinks. On macOS, VS Code files are linked into
`~/Library/Application Support/Code/User`; other application configs use
`~/.config`.
