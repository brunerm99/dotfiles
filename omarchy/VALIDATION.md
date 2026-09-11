# Validation on Kraken — 2026-09-10

All checks ran in the isolated `omarchy` Git worktree or temporary directories. No active desktop themes, app settings, running sessions, or notification daemons were changed.

| Check | Result |
| --- | --- |
| Regeneration | Running `generate-app-themes.py` produced byte-identical assets. |
| Palettes | JSON and TOML parsed; Ghostty has all 16 palette entries in both modes, matching the common source; VS Code editor and terminal base colors match. |
| Ghostty 1.3.1-arch2 | `+validate-config` accepted both named themes, both Omarchy `ghostty.conf` files, and the combined light/dark selector with Plex Mono using staged theme assets. |
| Neovim 0.12.4 | Headless, no user config or plugins: dark → light → dark updated Normal backgrounds, terminal colors, and diagnostic colors correctly while retaining `colors_name=workbench`. |
| Fish 4.8.1 | `fish --no-config --no-execute` accepted the function; sourcing and calling it in an isolated process assigned the expected command and quote colors. |
| VS Code | `code --list-extensions` with temporary user-data and extension directories detected `workbench.workbench-themes`. Both theme JSON files and the contribution manifest parsed. |
| GTK 3 | Native `gtk_css_provider_load_from_data` accepted both overlays without a parse error. Tested through ctypes because Kraken lacks the Python GI binding. |
| Installer | Dry run wrote no config directory; staging installed the expected assets; repeat install preserved identical-file mtimes; a changed theme was backed up; no Ghostty config or Fish startup file was created. |
| Repository | `git diff --check` passed. |

Limits: no live visual review of the native applications was performed. The VS Code check confirms extension discovery and theme JSON structure, not a rendered workbench. Mako and an Omarchy installation were unavailable on Kraken; their integration follows the inspected Omarchy theme format. The LazyVim adapter and Omarchy-wide switching need a full Omarchy session to validate end to end. Obsidian's snippet still needs enabling in a vault. GTK overlays apply only to GTK 3 and are manually selected; they do not theme Qt or GTK 4/libadwaita.

The Workbench rename was rechecked with deterministic regeneration, an isolated asset install, Ghostty named-theme/font parsing, VS Code extension discovery, Fish function execution, and Neovim dark/light/dark switching. A case-insensitive scan of tracked file contents and paths found no previous brand references.

## Light contrast adjustment — 2026-09-10

Body text now measures 10.11:1, muted text 5.71:1, and syntax/ANSI text at least 5.33:1 against the unchanged paper background. The dark palette and dark-only assets are unchanged; combined Neovim and Obsidian assets retain identical dark sections. Regeneration is deterministic, and the preview uses the same revised light text colors.

On macOS, Ghostty 1.3.1 accepted the installed configuration. Neovim 0.12.4 passed dark → light → dark checks with the existing user configuration, and the running editor was refreshed and queried to confirm the new light foreground and comment colors. Ghostty requires a configuration reload to show its new palette; Fish follows its ANSI colors automatically. These checks confirm configuration and highlight values, without a new native-app screenshot review.

## Ghostty active-pane outline — 2026-09-10

The focus shader compiled with `glslangValidator` using the documented Ghostty uniforms. An isolated asset install included the shader, and regeneration preserved the shader settings in the Ghostty snippet. On macOS, Ghostty 1.3.1 accepted the installed configuration and resolved the shader path with animation disabled and inactive split opacity set to 1. The outline uses the fixed Workbench orange accent and changes only the outer 3 px of a focused surface. Live Metal rendering and focus transitions still need checking after the user reloads Ghostty; configuration validation alone does not compile Ghostty's runtime shader.

The supplied macOS screenshots confirmed that the outline follows the active pane. They also exposed cursor-color inheritance: the Neovim pane had a blue border while the shell pane had orange. The shader now uses a fixed `#f07828` accent, independent of cursor uniforms; the revised shader passed GLSL compilation and the installed macOS configuration passed validation. Its final appearance needs a reload and visual check.

## Cursor visibility — 2026-09-11

Ghostty and Neovim use a dark copper cursor (`#914312`) with white text in light mode, and bright orange (`#f09050`) with charcoal text in dark mode. Cursor-to-background contrast is 5.33:1 and 6.04:1 respectively; text inside the cursor is 6.96:1 and 6.04:1. Neovim explicitly selects the Cursor highlight with a steady block in all modes. Ghostty defaults to a steady block and adds 2 px to bar/outline thickness; `no-cursor` disables shell integration's bar override in newly started shells.

The installed macOS Ghostty configuration validated, and Neovim passed light/dark/light cursor-highlight checks with the full user configuration. A separate Neovim TUI process emitted both expected OSC 12 cursor colors and a steady-block DECSCUSR command, with no insert-mode bar commands. The live editor was updated through RPC and its cursor setting/highlights were confirmed. Theme regeneration was deterministic. Ghostty still needs configuration reload, and existing shell integration handlers require a new shell for the prompt shape setting.

Insert-mode preference: restored the vertical line for insert/command-line insertion, a block for normal mode, and an underline for replace mode. The explicit Cursor highlight and disabled blinking remain in all modes. Full macOS configuration checks passed for the modal option and both cursor colors; the running editor was refreshed and queried to confirm the setting without changing its current mode. Ghostty’s thicker bars and high-contrast colors are unchanged.
