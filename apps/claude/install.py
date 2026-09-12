#!/usr/bin/env python3
"""Install the Workbench themes for Claude Code and select the one matching the system mode.

Links apps/claude/themes/*.json into ~/.claude/themes/ and sets "theme" in
~/.claude/settings.json to custom:workbench-light or custom:workbench-dark. Other
settings are preserved; a changed settings file is backed up first.
"""

import argparse
import json
import os
import platform
import shutil
import subprocess
import tempfile
from datetime import datetime
from pathlib import Path

HERE = Path(__file__).resolve().parent
HOME = Path.home()
CLAUDE = Path(os.environ.get("CLAUDE_CONFIG_DIR", HOME / ".claude"))
BACKUP = Path(os.environ.get("XDG_STATE_HOME", HOME / ".local/state")) / "dotfiles/backups" / (
    "claude-" + datetime.now().strftime("%Y%m%d-%H%M%S-%f")
)

DESKTOP_STEPS = """\
The Claude desktop app keeps its appearance in the app, not in a file. Once per machine:
  Settings > Claude Code > Appearance: Interface font "System", Code font "IBM Plex Mono"
  Settings > Appearance: Chat font "System"
"System" resolves through fontconfig/GTK, which this setup points at IBM Plex Serif.
The app follows the system light/dark mode; its code-block theme has no Workbench option."""


def system_mode():
    if platform.system() == "Darwin":
        result = subprocess.run(["defaults", "read", "-g", "AppleInterfaceStyle"], capture_output=True, text=True)
        return "dark" if result.returncode == 0 and "Dark" in result.stdout else "light"
    # Prefer the system gsettings: a Homebrew one reads a different backend and reports defaults.
    gsettings = "/usr/bin/gsettings" if os.path.exists("/usr/bin/gsettings") else "gsettings"
    try:
        value = subprocess.check_output(
            [gsettings, "get", "org.gnome.desktop.interface", "color-scheme"], text=True, stderr=subprocess.DEVNULL
        )
    except (OSError, subprocess.CalledProcessError):
        return "dark"
    return "dark" if "prefer-dark" in value else "light"


def backup(path):
    if path.exists() or path.is_symlink():
        saved = BACKUP / path.relative_to(HOME)
        saved.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, saved, follow_symlinks=False)


def link_themes():
    target_dir = CLAUDE / "themes"
    target_dir.mkdir(parents=True, exist_ok=True)
    for source in sorted((HERE / "themes").glob("workbench-*.json")):
        target = target_dir / source.name
        if target.is_symlink() and target.resolve() == source.resolve():
            continue
        backup(target)
        target.unlink(missing_ok=True)
        target.symlink_to(source)
        print(f"linked  {target}")


def select_theme(mode):
    path = CLAUDE / "settings.json"
    settings = json.loads(path.read_text()) if path.exists() else {}
    theme = f"custom:workbench-{mode}"
    if settings.get("theme") == theme:
        return
    backup(path)
    settings["theme"] = theme
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, prefix=".settings-", delete=False) as stream:
        json.dump(settings, stream, indent=2)
        stream.write("\n")
        temporary = Path(stream.name)
    temporary.chmod(path.stat().st_mode & 0o777 if path.exists() else 0o644)
    temporary.replace(path)
    print(f"updated {path}: theme = {theme}")


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--mode", choices=["light", "dark", "system"], default="system",
                        help="which Workbench theme to select (default: follow the system mode)")
    parser.add_argument("--quiet", action="store_true", help="skip the desktop app reminder")
    args = parser.parse_args()
    link_themes()
    select_theme(system_mode() if args.mode == "system" else args.mode)
    if BACKUP.exists():
        print(f"Previous settings saved in {BACKUP}")
    if not args.quiet:
        print(DESKTOP_STEPS)


if __name__ == "__main__":
    main()
