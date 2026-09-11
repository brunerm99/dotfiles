# Rimeworks for Omarchy — example

Two starter themes based on the light/dark app tokens in Rimeworks style guide v3 (2026-08-28), read from `kraken:~/documents/rimeworks/style-guide.html`.

Default interface: **IBM Plex Serif**. Terminal, code, and numeric readouts: **IBM Plex Mono**. The guide explicitly uses Serif as the product body face.

| Role | Light | Dark |
| --- | --- | --- |
| Background | `#e8e0d8` | `#1e2c31` |
| Surface | `#ffffff` | `#283a40` |
| Text | `#2d3e44` | `#d4d0cc` |
| Muted | `#5a6f76` | `#8fa3ab` |
| Border | `#c1c0bc` | `#3d5058` |
| Accent | `#f07828` | `#f07828` |

The main tokens are preserved. Light ANSI text colors are darker adaptations of the guide's accents, each meeting 4.5:1 contrast on the paper background. Bright ANSI accents intentionally reuse those readable values. `palette-source.json` records the unmodified input palette.

Open `preview.html` in a browser to compare the two modes. The preview loads IBM Plex fonts from Google Fonts and requires an internet connection for those fonts.

## Try on an Omarchy 3 installation

These commands are examples to run on the target Linux machine, from the `omarchy/` directory in this repository (`cd omarchy`). They have not been run on your computers. If either destination theme already exists, rename or back it up before copying.

```bash
sudo pacman -S --needed ttf-ibm-plex
mkdir -p ~/.config/omarchy/themes
cp -R rimeworks-light rimeworks-dark ~/.config/omarchy/themes/

omarchy-theme-set rimeworks-dark
# Or:
omarchy-theme-set rimeworks-light
```

Each theme includes `colors.toml`, a Hyprland orange focus border with 5px corners, Waybar typography, and Walker colors/typography. The light theme includes `light.mode`. Omarchy generates the remaining app color configurations from `colors.toml`.

## Font defaults

Font settings are separate from the color palette. On Omarchy, set the terminal monospace font, then add generic font defaults and the GTK interface font:

```bash
omarchy-font-set "IBM Plex Mono"
mkdir -p ~/.config/fontconfig/conf.d
cp fonts/99-rimeworks.conf ~/.config/fontconfig/conf.d/
fc-cache -f
gsettings set org.gnome.desktop.interface font-name 'IBM Plex Serif 11'
gsettings set org.gnome.desktop.interface document-font-name 'IBM Plex Serif 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'IBM Plex Mono 11'
omarchy-restart-waybar
```

`99-rimeworks.conf` maps both generic UI families (serif and sans-serif) to IBM Plex Serif, and monospace to IBM Plex Mono. Explicit app font choices may still override these defaults. The theme's Waybar selectors keep labels in Serif and readouts in Mono. Existing Nerd Font support is used as an icon fallback; IBM Plex Mono itself is unpatched. Restart affected applications to load changed fonts.

## Scope and verification

This is an example palette/theme package, not a full GTK widget theme or a custom Neovim theme. The desktop preview illustrates the design; it is not a screenshot of a running Omarchy session. File-manager surfaces may differ under the target GTK theme. No wallpaper is bundled.

Validated palette structure, hexadecimal values, text contrast, fontconfig XML, and the preview's light/dark interaction. Linux/Hyprland runtime testing is still needed. Built against Omarchy's `master` theme format inspected on 2026-09-10; later versions may use different paths or components.

Sources: [Omarchy theme manual](https://learn.omacom.io/2/the-omarchy-manual/92/making-your-own-theme), [template generator](https://github.com/omacom/omarchy/blob/master/bin/omarchy-theme-set-templates), [font command](https://github.com/omacom/omarchy/blob/master/bin/omarchy-font-set), [Arch IBM Plex package](https://archlinux.org/packages/extra/any/ttf-ibm-plex/).
