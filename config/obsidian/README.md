# Workbench for Obsidian

Light and dark palettes matching the Workbench Ghostty and Neovim themes.
Obsidian stores themes per vault, so after cloning dotfiles, run:

```sh
python3 config/obsidian/install.py /path/to/vault
```

The installer copies the theme and merges only `cssTheme` and `theme` into
the vault's appearance settings. Fonts, snippets, and other preferences stay
intact. Replaced files are backed up under `.obsidian/backups/`.
Reload Obsidian if it is already open. Re-run the installer after theme updates.
