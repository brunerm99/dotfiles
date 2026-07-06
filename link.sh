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
  tmp_link="$(mktemp -u "$(dirname "$target")/.$(basename "$target").tmp.XXXXXX")"
  ln -s "$source" "$tmp_link"

  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -d "$target" && ! -L "$target" ]]; then
      rm -f "$tmp_link"
      printf 'refusing to replace directory target: %s\n' "$target" >&2
      exit 1
    fi

    if cmp -s "$source" "$target"; then
      mv -Tf "$tmp_link" "$target"
      printf 'linked  %s -> %s\n' "$target_rel" "$source_rel"
      return
    else
      mkdir -p "$backup_root/$(dirname "$target_rel")"
      cp -a "$target" "$backup_root/$target_rel"
      backup_used=1
    fi
  fi

  mv -Tf "$tmp_link" "$target"
  printf 'linked  %s -> %s\n' "$target_rel" "$source_rel"
}

while IFS= read -r -d '' source_rel; do
  case "$source_rel" in
    home/*)
      link_file "$source_rel" "${source_rel#home/}"
      ;;
    config/*)
      link_file "$source_rel" ".config/${source_rel#config/}"
      ;;
  esac
done < <(git -C "$repo" ls-files -z)

if [[ "$backup_used" -eq 1 ]]; then
  printf 'backups written to %s\n' "$backup_root"
fi
