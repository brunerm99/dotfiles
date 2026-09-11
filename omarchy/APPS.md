# Kraken app themes

The palettes support Ghostty, Neovim, Fish, VS Code, Obsidian, and GTK 3 apps such as Nemo. Omarchy supplies Waybar, Walker, Hyprland, and **Mako** notification integration. Zed, Kitty, OpenCode, Dunst, and Zellij are outside this package's app integration scope.

All generated assets use the same `workbench-light/colors.toml` and `workbench-dark/colors.toml`, with surface colors from `palette-source.json`. IBM Plex Serif is the default interface/body font; IBM Plex Mono is the terminal/editor font. Install `ttf-ibm-plex` on the target Arch machine first.

## Install assets

From this directory:

```bash
python3 install-app-themes.py --dry-run
python3 install-app-themes.py
```

The installer adds named themes and a Fish function to your config directory, plus a local VS Code theme extension. It does not select themes, edit app settings, install packages, or restart apps. Changed existing theme assets are moved to timestamped backups; identical files are left alone. `--config-dir` and `--extensions-dir` allow an isolated staging directory or a different VS Code profile location.

Obsidian's snippet is installed per vault manually. The fontconfig defaults in `fonts/` are also opt-in; see the main README. Existing keybindings, language servers, plugins, and desktop configuration remain under their current configs.

## Ghostty

The named `WorkbenchLight` and `WorkbenchDark` themes include all 16 terminal colors, cursor, selection, background, and foreground. Merge `apps/snippets/ghostty.conf` into your existing Ghostty config, replacing its current font/theme directives:

```ini
font-family = ""
font-family = "IBM Plex Mono"
theme = light:WorkbenchLight,dark:WorkbenchDark
```

The empty font entry clears earlier font families so Plex becomes the primary font. This follows the desktop's light/dark preference. Kraken currently selects `KrakenLight`/`KrakenDark`, so that selector must be replaced. Keep your existing split navigation and other keybindings.

On Omarchy, the theme directories also contain explicit `ghostty.conf` files. Retain Omarchy's existing include for `~/.config/omarchy/current/theme/ghostty.conf` and set the font separately; do not also add the named-theme selector in that setup. This lets `omarchy-theme-set` remain the color source. Restart Ghostty after changing the font.

## Neovim

`apps/config/nvim/colors/workbench.lua` is a standalone colorscheme with UI, Treesitter, semantic tokens, diagnostics, diffs, GitSigns, picker groups, and terminal colors. It follows `background` and requires no theme plugin.

In Kraken's `init.lua`, **replace** `require("config.theme")` with:

```lua
vim.opt.termguicolors = true
vim.cmd.colorscheme("workbench")
```

Restart Neovim afterward. Kraken's existing `config.theme` registers Tokyo Night callbacks that would otherwise reclaim the colorscheme; do not load both initializers. Use `:set background=light` or `:set background=dark` to switch; Neovim reloads the colorscheme. Supported terminals can also report their background preference.

The Omarchy theme directories contain a `neovim.lua` LazyVim adapter and a bundled copy of the same colorscheme. Standard Omarchy Neovim loads that adapter during theme changes; restart Neovim if the current session has not picked up the new theme.

## Fish

Run `workbench` in Fish to apply syntax, completion, pager, selection, and prompt-role colors. Add this call at the end of `~/.config/fish/config.fish` to persist it:

```fish
if status is-interactive
    workbench
end
```

The function uses ANSI color names, so Fish follows Ghostty's light/dark palette automatically. Running it after the startup `conf.d` files overrides Kraken's frozen Fish theme. Custom prompt functions that hardcode RGB values need their own adjustment.

## VS Code

The installer adds a local, code-free `workbench.workbench-themes` extension containing both workbench, syntax, semantic, and integrated-terminal palettes. Restart VS Code and select **Workbench Light** or **Workbench Dark** in the Color Theme picker.

Merge the keys in `apps/snippets/vscode-settings.json` into your existing settings to use Plex Mono and follow the system appearance. VS Code does not expose a supported global workbench font-family setting; its UI keeps the application's font, while editors and terminals use Plex Mono.

For Omarchy, install these assets **before** selecting the Omarchy theme. Each theme's `vscode.json` points to the local extension ID. There is no Marketplace publication, so the local installation is required. Omarchy selects the corresponding variant as part of `omarchy-theme-set`.

## Obsidian

Copy `apps/obsidian/workbench.css` to `<vault>/.obsidian/snippets/workbench.css` and enable **workbench** in Settings → Appearance → CSS snippets. It follows Obsidian's light/dark mode, sets Plex Serif for interface and body, and Plex Mono for code. It covers surfaces, links, code, headings, selection, and graph colors. Use Obsidian's default base theme; community themes may override these variables.

The Omarchy theme directories also include `obsidian.css` for Omarchy's existing Obsidian theme integration. Use that integration or the standalone snippet, so there is a single source for the active palette.

## Nemo and other GTK 3 apps

The installer places optional overlays under `~/.config/gtk-3.0/workbench/`. With Adwaita as the base GTK theme, put this import at the beginning of `~/.config/gtk-3.0/gtk.css`:

```css
@import url("workbench/dark.css");
```

Use `light.css` for light mode, then restart the application. Do not replace unrelated custom GTK rules. These overlays style common windows, headers, file views, sidebars, entries, buttons, menus, and selections. They are not a complete GTK theme and do not cover Qt/KDE applications or GTK 4/libadwaita. This optional overlay is manually selected and is not automatically switched by Omarchy.

## Mako notifications

Each Omarchy theme contains `mako.ini`, which includes Omarchy's normal Mako layout and behavior, then applies the Workbench foreground/background, orange border, and **IBM Plex Serif 11**. Omarchy selects it and restarts Mako with its normal theme workflow. No Dunst config or daemon replacement is included.

## Regeneration and validation

```bash
python3 generate-app-themes.py
```

Requires Python 3.11 or newer, with no third-party dependencies. Generated assets are committed so normal installation does not require generation. Keep the two `colors.toml` files as the terminal palette source; update `palette-source.json` when changing the surface tokens.

Validation uses Kraken's native Ghostty parser, Neovim headless highlight checks in both modes, Fish's parser, GTK 3's CSS parser, JSON/extension structure checks, and an isolated installer exercise. See `VALIDATION.md` for actual results and remaining runtime limits.

Format references: [Ghostty](https://ghostty.org/docs/config/reference), [Neovim colorschemes](https://neovim.io/doc/user/syntax.html#colorscheme), [Fish highlighting](https://fishshell.com/docs/current/interactive.html#syntax-highlighting), [VS Code themes](https://code.visualstudio.com/api/extension-guides/color-theme), [Obsidian CSS variables](https://docs.obsidian.md/Reference/CSS+variables/Foundations/Colors), [GTK 3 CSS](https://docs.gtk.org/gtk3/css-overview.html), and [Omarchy theme source](https://github.com/omacom/omarchy/tree/master/default/themed).
