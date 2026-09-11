#!/usr/bin/env python3
"""Install theme assets without activating them or changing existing app settings."""
import argparse
from datetime import datetime, timezone
import os
from pathlib import Path
import shutil


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--config-dir', type=Path, default=Path(os.environ.get('XDG_CONFIG_HOME', Path.home() / '.config')))
    parser.add_argument('--extensions-dir', type=Path, default=Path.home() / '.vscode/extensions')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    root = Path(__file__).resolve().parent
    stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    mappings = [
        (root / 'apps/config', args.config_dir),
        (root / 'apps/vscode/workbench-themes', args.extensions_dir / 'workbench.workbench-themes-0.1.0'),
    ]
    for source_root, destination_root in mappings:
        for source in sorted(source_root.rglob('*')):
            if not source.is_file():
                continue
            destination = destination_root / source.relative_to(source_root)
            if destination.is_file() and destination.read_bytes() == source.read_bytes():
                print(f'unchanged {destination}')
                continue
            print(f'install   {destination}')
            if args.dry_run:
                continue
            destination.parent.mkdir(parents=True, exist_ok=True)
            if destination.exists() or destination.is_symlink():
                backup = destination.with_name(destination.name + '.backup-' + stamp)
                if backup.exists():
                    raise FileExistsError(backup)
                destination.rename(backup)
            shutil.copyfile(source, destination)
    print('Theme assets only. Follow APPS.md to select themes and fonts; no application was restarted.')


if __name__ == '__main__':
    main()
