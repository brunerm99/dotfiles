# Repositories on the Omarchy laptop

Personal GitHub repositories were selected by recent activity (90 days), plus
rfapps and videos. Rainmaker repositories are excluded. Chill repositories will
be added later. `systui` and `weather-sim` were removed intentionally and should
not be restored.

All paths below are relative to `/home/marchall/documents`.

| Checkout | Setup and verification |
| --- | --- |
| `rftk` (GitHub `rfapps`) | `uv sync --all-packages --all-groups --locked`; desktop and license-worker `npm ci`; Electron runtime verified; pinned Rust 1.93.0 with wasm32 target installed |
| `fin` | `uv sync --locked`; frontend `npm ci` and production build passed |
| `lache` | pnpm 10.32.1 frozen install and production build passed |
| `library` | `uv sync --frozen`; Docker image `local/library-index:latest` built, including verified offline reader assets; vault setup pending |
| `caseview` | `uv sync --locked` |
| `mediakit` | `uv sync --locked`; external account credentials still required |
| `curfew` | Pinned Rust 1.93.1 installed and `cargo fetch --locked` completed; Unreal project is not yet present in this checkout |
| `manim` | Python 3.12 environment with an editable install of this ManimGL fork |
| `videos` | Python 3.12 environment with Manim CE, the local ManimGL fork, and scientific/radar libraries; imports passed |
| `videos-private` | Full clone; `.venv` links to `../videos/.venv` because dependencies match |
| `notebooks` | Python 3.12 environment with Marimo, JupyterLab, RF/radar and geospatial libraries; imports passed |
| `ytnb` | Python 3.12 environment with Marimo, RF/scientific libraries, and widgets; imports passed |
| `homeassistant` | Configuration checkout; existing homelab services were not deployed on this laptop |
| `rimeworks` | Documentation/tools checkout; remote service credentials are not included |

The source checkouts remain clean. The video repositories include full history
and checked-in renders, using about 6 GB each. `documents/work/tries` is for
disposable experiments, not employment projects or the main repository folder.

System tools installed for these projects: `just`, `dvisvgm`, and TeX Live's
LaTeX, extra LaTeX, recommended fonts, and math/science collections. Manim CE
successfully compiled a sample equation through LaTeX to SVG.

## Python environments without project lockfiles

The versions installed for Manim, videos, notebooks, and ytnb are recorded in
`python-environments/`. From the corresponding checkout, recreate one with:

```sh
uv venv --python 3.12 .venv
uv pip install --python .venv/bin/python -r ~/.dotfiles/omarchy/python-environments/videos.txt
source .venv/bin/activate.fish
```

Choose the matching requirements file. Both Manim engines are installed because
the video sources import both `manim` and `manimlib`. The videos do not declare
version constraints; older scenes may need version adjustments. Custom helpers
such as `MF_Tools` and `melp`, Blender-only scripts, and private input assets are
not available from these declared environments. No full video render has been
verified.

For notebooks: `.venv/bin/marimo edit` or `.venv/bin/jupyter lab`. A notebook with
inline dependency metadata can also run in its own environment using
`uv run --script filename.py`.

## Library after Obsidian Sync

Library is built but not running or enabled yet. Sign in to Obsidian Sync and
download the vault containing `References`. Its exact local path is required
before configuring mounts. Follow the repository's `.env.example`, with
`REFERENCES_DIR` pointing to that folder and `LIBRARY_SYNC_DIR` to its
`_library-sync` subdirectory. Enable Obsidian's **Sync all other types** option.

The prepared system unit is `services/library-index.service`; it uses the
checkout's Docker Compose configuration, binds only `127.0.0.1:8080`, and starts
without rebuilding or downloading. Once the paths are configured and checked,
install it under `/etc/systemd/system/`, reload systemd, and enable it with
`systemctl enable --now library-index.service`.

Source documents stay read-only. Databases, caches, credentials, and Obsidian
profiles must remain outside dotfiles and outside the portable sync folder.
