# Validation on Kraken — 2026-09-10

All checks ran in the isolated `omarchy` Git worktree or temporary directories. No active desktop themes, app settings, running sessions, or notification daemons were changed.

| Check | Result |
| --- | --- |
| Regeneration | Running `generate-app-themes.py` produced byte-identical assets. |
| Palettes | JSON and TOML parsed; Ghostty has all 16 palette entries in both modes, matching the common source; VS Code editor and terminal base colors match. |
| Ghostty 1.3.1-arch2 | `+validate-config` accepted both named themes, both Omarchy `ghostty.conf` files, and the combined light/dark selector with Plex Mono using staged theme assets. |
| Neovim 0.12.4 | Headless, no user config or plugins: dark → light → dark updated Normal backgrounds, terminal colors, and diagnostic colors correctly while retaining `colors_name=rimeworks`. |
| Fish 4.8.1 | `fish --no-config --no-execute` accepted the function; sourcing and calling it in an isolated process assigned the expected command and quote colors. |
| VS Code | `code --list-extensions` with temporary user-data and extension directories detected `rimeworks.rimeworks-themes`. Both theme JSON files and the contribution manifest parsed. |
| GTK 3 | Native `gtk_css_provider_load_from_data` accepted both overlays without a parse error. Tested through ctypes because Kraken lacks the Python GI binding. |
| Installer | Dry run wrote no config directory; staging installed the expected assets; repeat install preserved identical-file mtimes; a changed theme was backed up; no Ghostty config or Fish startup file was created. |
| Repository | `git diff --check` passed. |

Limits: no live visual review of the native applications was performed. The VS Code check confirms extension discovery and theme JSON structure, not a rendered workbench. Mako and an Omarchy installation were unavailable on Kraken; their integration follows the inspected Omarchy theme format. The LazyVim adapter and Omarchy-wide switching need a full Omarchy session to validate end to end. Obsidian's snippet still needs enabling in a vault. GTK overlays apply only to GTK 3 and are manually selected; they do not theme Qt or GTK 4/libadwaita.
