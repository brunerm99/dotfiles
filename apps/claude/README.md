# Workbench for Claude

Light and dark Claude Code themes matching the Workbench Ghostty, Neovim, VS Code
and Obsidian themes, plus the one-time desktop app settings.

## Claude Code

Claude Code loads custom themes from `~/.claude/themes/<slug>.json` and selects one
with `"theme": "custom:<slug>"` in `~/.claude/settings.json`. Its `auto` mode only
switches between the built-in light and dark themes, so the light/dark switch here
rewrites the setting instead. Running sessions pick the change up; `/theme` also
lists both Workbench themes.

```sh
python3 apps/claude/install.py            # follow the system mode
python3 apps/claude/install.py --mode dark
```

`apply-appearance.py` runs the installer, and `~/.config/waybar/scripts/appearance.py`
re-selects the matching theme whenever the system switches modes. Other settings in
`settings.json` stay intact; a changed file is backed up under
`~/.local/state/dotfiles/backups/`.

The theme files are generated: edit the palettes in `generate-themes.py` and re-run it.
Text tokens use the darker terminal variants in light mode for legibility, diff
backgrounds are tints of the mode's background, and the base is the daltonized
built-in so tokens added by newer Claude Code releases keep colorblind-friendly
defaults. Fonts come from the terminal, so Ghostty already renders it in IBM Plex Mono.

## Claude desktop app

The desktop app stores its appearance inside the app (synced to the account for
some options), so there is no file to link. Set once per machine:

- Settings → Claude Code → Appearance → Interface font: **System**
- Settings → Claude Code → Appearance → Code font: **IBM Plex Mono**
- Settings → Appearance → Chat font: **System**

"System" resolves through GTK/fontconfig, which `apply-appearance.py` points at
IBM Plex Serif, so menus, sidebar, chat and responses render in Plex Serif and
code and the terminal in Plex Mono. The app follows the system light/dark mode.
Its colors and code-block themes are fixed by the app and have no Workbench option.
