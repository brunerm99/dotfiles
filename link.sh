#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/$(date +%Y%m%d-%H%M%S)"
backup_used=0

link_file() {
  local source_rel="$1"
  local target_rel="$2"
  local source="$repo/$source_rel"
  local target="$HOME/$target_rel"

  if [[ ! -e "$source" ]]; then
    printf 'missing source: %s\n' "$source" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    printf 'ok      %s\n' "$target_rel"
    return
  fi

  local tmp_link
  tmp_link="$(mktemp -u "$target.tmp.XXXXXX")"
  ln -s "$source" "$tmp_link"

  if [[ -e "$target" || -L "$target" ]]; then
    if cmp -s "$source" "$target"; then
      mv -Tf "$tmp_link" "$target"
      printf 'linked  %s -> %s\n' "$target_rel" "$source_rel"
      return
    else
      mkdir -p "$backup_root/$(dirname "$target_rel")"
      mv "$target" "$backup_root/$target_rel"
      backup_used=1
    fi
  fi

  mv -Tf "$tmp_link" "$target"
  printf 'linked  %s -> %s\n' "$target_rel" "$source_rel"
}

link_file "home/.bashrc" ".bashrc"
link_file "home/.gitconfig" ".gitconfig"
link_file "home/.profile" ".profile"
link_file "home/.vimrc" ".vimrc"

link_file "config/Code/User/keybindings.json" ".config/Code/User/keybindings.json"
link_file "config/Code/User/settings.json" ".config/Code/User/settings.json"

link_file "config/fish/config.fish" ".config/fish/config.fish"
link_file "config/fish/completions/bun.fish" ".config/fish/completions/bun.fish"
link_file "config/fish/completions/obsidian-cli.fish" ".config/fish/completions/obsidian-cli.fish"
link_file "config/fish/conf.d/fish_frozen_key_bindings.fish" ".config/fish/conf.d/fish_frozen_key_bindings.fish"
link_file "config/fish/conf.d/fish_frozen_theme.fish" ".config/fish/conf.d/fish_frozen_theme.fish"
link_file "config/fish/conf.d/rustup.fish" ".config/fish/conf.d/rustup.fish"
link_file "config/fish/functions/blender.fish" ".config/fish/functions/blender.fish"
link_file "config/fish/functions/cls.fish" ".config/fish/functions/cls.fish"
link_file "config/fish/functions/cplast.fish" ".config/fish/functions/cplast.fish"
link_file "config/fish/functions/g.fish" ".config/fish/functions/g.fish"
link_file "config/fish/functions/ga.fish" ".config/fish/functions/ga.fish"
link_file "config/fish/functions/gc.fish" ".config/fish/functions/gc.fish"
link_file "config/fish/functions/gca.fish" ".config/fish/functions/gca.fish"
link_file "config/fish/functions/gd.fish" ".config/fish/functions/gd.fish"
link_file "config/fish/functions/gl.fish" ".config/fish/functions/gl.fish"
link_file "config/fish/functions/gll.fish" ".config/fish/functions/gll.fish"
link_file "config/fish/functions/gp.fish" ".config/fish/functions/gp.fish"
link_file "config/fish/functions/gpl.fish" ".config/fish/functions/gpl.fish"
link_file "config/fish/functions/gs.fish" ".config/fish/functions/gs.fish"
link_file "config/fish/functions/gsp.fish" ".config/fish/functions/gsp.fish"
link_file "config/fish/functions/gst.fish" ".config/fish/functions/gst.fish"
link_file "config/fish/functions/ls.fish" ".config/fish/functions/ls.fish"
link_file "config/fish/functions/tree.fish" ".config/fish/functions/tree.fish"
link_file "config/fish/functions/unp.fish" ".config/fish/functions/unp.fish"
link_file "config/fish/functions/z.fish" ".config/fish/functions/z.fish"

link_file "config/ghostty/config" ".config/ghostty/config"

link_file "config/hypr/hyprland.conf" ".config/hypr/hyprland.conf"
link_file "config/hypr/hyprland.lua" ".config/hypr/hyprland.lua"
link_file "config/hypr/hyprlock.conf" ".config/hypr/hyprlock.conf"
link_file "config/hypr/hyprpaper.conf" ".config/hypr/hyprpaper.conf"
link_file "config/hypr/scripts/toggle-workspace-layout" ".config/hypr/scripts/toggle-workspace-layout"

link_file "config/hypremoji/config.json" ".config/hypremoji/config.json"
link_file "config/hypremoji/hypremoji.conf" ".config/hypremoji/hypremoji.conf"

link_file "config/waybar/config.jsonc" ".config/waybar/config.jsonc"
link_file "config/waybar/style.css" ".config/waybar/style.css"
link_file "config/waybar/scripts/workspace-button.py" ".config/waybar/scripts/workspace-button.py"
link_file "config/waybar/scripts/workspace-watch.py" ".config/waybar/scripts/workspace-watch.py"

link_file "config/zellij/config.kdl" ".config/zellij/config.kdl"
link_file "config/zellij/layouts/viewshed.kdl" ".config/zellij/layouts/viewshed.kdl"

if [[ "$backup_used" -eq 1 ]]; then
  printf 'backups written to %s\n' "$backup_root"
fi
