# dotfiles

Personal dotfiles for this machine.

Current branch: `machine/kraken`

This branch intentionally tracks only the config that is useful to recreate this
machine:

- Hyprland, Hyprlock, Hyprpaper, HyprEmoji
- Waybar
- Ghostty
- VS Code user settings and keybindings
- Vim
- Fish shell
- Zellij
- Basic Bash, profile, and Git config

Runtime state, backups, generated caches, editor history, package state, and
private app data are intentionally left out.

## Link

From this repo:

```sh
./link.sh
```

The linker is idempotent. If it replaces an existing non-linked file, it writes a
backup under `${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/`.
