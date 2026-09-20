# Local Omarchy configuration

These files mirror selected live files under `~/.config` on the Omarchy laptop.
Copy individual files to the matching locations when applying them elsewhere;
the touchpad name and plugin IDs are machine-specific.

Includes Ghostty tabs and bindings, Hyprland shortcuts and input preferences,
Fish functions, the native-package Neovim setup from the Kraken machine,
Workbench app settings, and customized appearance, clock, menu, and workspace
plugins. Neovim loads the active Workbench palette and follows live Light/Dark
theme changes. The appearance button at the right of the bar switches the whole
Omarchy session between Workbench Light and Workbench Dark while preserving the
current wallpaper. The
theme-set hook keeps the custom GTK 3 overlay on the matching Workbench mode.
The calendar's W key opens a day view; Google
event synchronization is not implemented yet and requires OAuth setup.

`user-dirs.dirs` keeps the standard user directories lowercase, including
`~/documents`. `codex-desktop/settings.toml` records the matching Codex
projectless-task root; merge its `[desktop]` key into `~/.codex/config.toml`.

The menu clone falls back to the installed AppLibrary QML component when the
shell injects a null application library. This preserves app discovery, hidden
entry filtering, icons, and launching. It requires the installed Omarchy shell.
This is a configuration snapshot, not a standalone installer.

Fish is the login shell and Ghostty's explicit command. Alt+S toggles `sudo` on
the command line. Functions were ported from the Kraken and MacBook dotfiles;
macOS paths were replaced with portable commands. Zellij and its `z` alias are
intentionally absent. Optional app wrappers need their corresponding apps.

Super+U opens the power menu. Super+F1–F12 selects workspaces 11–22; adding Shift
moves the current window there. The bar shows occupied workspaces and the active
workspace even when it is empty. When the active workspace uses stacked mode,
up/down controls appear beside the workspace selector for mouse navigation.

Obsidian uses XWayland with a 1.25 device scale: native Wayland on this machine's
1.6 monitor scale renders into only part of the window. Its vault has not been
synced yet, so the Workbench Obsidian snippet is not applied to a vault.

Install the generated Workbench assets with `../install-app-themes.py` before
using the GTK CSS import or the named VS Code theme. GitHub credentials are
provided by `gh auth git-credential`; authenticate with `gh auth login` on a new
machine. Credentials are not included here.

Flameshot must be installed for Super+I. Discord and WhatsApp remain available
without keybindings. X and YouTube launchers were removed from the live machine.

The pointer size is also applied through GSettings:

```sh
gsettings set org.gnome.desktop.interface cursor-size 18
```

After applying Hyprland files, run `hyprctl reload` and `hyprctl configerrors`.
Reload Ghostty with `omarchy restart terminal`. User shell plugins hot-reload;
use `omarchy restart shell` if needed.
