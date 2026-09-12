#!/usr/bin/env python3
"""Install Workbench into an existing Obsidian vault without replacing its settings."""

import argparse
import json
import shutil
from datetime import datetime
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("vault", type=Path, help="Path to the Obsidian vault")
args = parser.parse_args()
config = args.vault.expanduser().resolve() / ".obsidian"
if not config.is_dir():
    parser.error(f"Not an existing Obsidian vault: {config.parent}")

source = Path(__file__).resolve().parent
appearance = config / "appearance.json"
settings = json.loads(appearance.read_text()) if appearance.exists() else {}
updates = json.loads((source / "appearance.json").read_text())
theme = config / "themes" / "Workbench"
files = [(source / "themes" / "Workbench" / name, theme / name)
         for name in ("manifest.json", "theme.css")]
changed = [target for origin, target in files
           if target.exists() and origin.read_bytes() != target.read_bytes()]
if appearance.exists() and any(settings.get(k) != v for k, v in updates.items()):
    changed.append(appearance)
if changed:
    backup = config / "backups" / ("workbench-" + datetime.now().strftime("%Y%m%d-%H%M%S-%f"))
    for target in changed:
        saved = backup / target.relative_to(config)
        saved.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(target, saved)
    print(f"Backed up previous configuration to {backup}")

theme.mkdir(parents=True, exist_ok=True)
for origin, target in files:
    if not target.exists() or origin.read_bytes() != target.read_bytes():
        shutil.copy2(origin, target)
if not appearance.exists() or any(settings.get(k) != v for k, v in updates.items()):
    settings.update(updates)
    appearance.write_text(json.dumps(settings, indent=2) + "\n")
print(f"Workbench installed in {config.parent}")
