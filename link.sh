#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_home="${DOTFILES_TARGET_HOME:-$HOME}"
state_home="${DOTFILES_STATE_HOME:-${XDG_STATE_HOME:-$HOME/.local/state}}"
backup_root="$state_home/dotfiles/backups/$(date +%Y%m%d-%H%M%S)"
backup_used=0

link_file() {
  local source_rel="$1"
  local target_rel="$2"
  local source="$repo/$source_rel"
  local target="$target_home/$target_rel"

  if [[ ! -e "$source" ]]; then
    printf 'missing source: %s\n' "$source" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    printf 'ok      %s\n' "$target_rel"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -d "$target" && ! -L "$target" ]]; then
      printf 'refusing to replace directory target: %s\n' "$target" >&2
      exit 1
    fi

    if cmp -s "$source" "$target" 2>/dev/null; then
      ln -sfn "$source" "$target"
      printf 'linked  %s -> %s\n' "$target_rel" "$source_rel"
      return
    else
      mkdir -p "$backup_root/$(dirname "$target_rel")"
      cp -a "$target" "$backup_root/$target_rel"
      backup_used=1
    fi
  fi

  ln -sfn "$source" "$target"
  printf 'linked  %s -> %s\n' "$target_rel" "$source_rel"
}

if [[ "$(uname -s)" == "Darwin" ]]; then
  vscode_user_dir="Library/Application Support/Code/User"
else
  vscode_user_dir=".config/Code/User"
fi

while IFS= read -r -d '' source_rel; do
  case "$source_rel" in
    home/*)
      link_file "$source_rel" "${source_rel#home/}"
      ;;
    config/Code/User/*)
      link_file "$source_rel" "$vscode_user_dir/${source_rel#config/Code/User/}"
      ;;
    config/*)
      link_file "$source_rel" ".config/${source_rel#config/}"
      ;;
  esac
done < <(git -C "$repo" ls-files -z)

if [[ "$backup_used" -eq 1 ]]; then
  printf 'backups written to %s\n' "$backup_root"
fi
