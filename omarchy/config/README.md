# Local Omarchy configuration

These files mirror selected live files under `~/.config` on the Omarchy laptop.
Copy individual files to the matching locations when applying them elsewhere;
the touchpad name and plugin IDs are machine-specific.

Includes Ghostty tabs and bindings, Hyprland shortcuts and input preferences,
and the customized clock plugin. The calendar's W key opens a day view; Google
event synchronization is not implemented yet and requires OAuth setup.

The shell layout also references the existing `marchall.menu` plugin, which is
not included here. This is a configuration snapshot, not a standalone installer.

Flameshot must be installed for Super+I. Discord and WhatsApp remain available
without keybindings. X and YouTube launchers were removed from the live machine.

The pointer size is also applied through GSettings:

```sh
gsettings set org.gnome.desktop.interface cursor-size 18
```

After applying Hyprland files, run `hyprctl reload` and `hyprctl configerrors`.
Reload Ghostty with `omarchy restart terminal`. User shell plugins hot-reload;
use `omarchy restart shell` if needed.
