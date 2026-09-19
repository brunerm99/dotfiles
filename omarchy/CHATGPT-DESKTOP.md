# ChatGPT Desktop

The Workbench generator creates native ChatGPT Desktop chrome themes for both
light and dark modes. They use the Workbench surface, ink, accent, diff, and
skill colors; IBM Plex Serif for the interface and content; and IBM Plex Mono
for code. The app remains in system appearance mode so it follows Omarchy's
light/dark selection.

`apps/config/codex-desktop/workbench-theme.toml` is the tracked settings
snippet. The app's live settings are in the existing `[desktop]` table in
`~/.codex/config.toml`; merge the snippet's keys into that table rather than
adding a second table header. Applying the same values through the app's
Appearance settings takes effect immediately; after a direct config edit,
restart the app so it reloads the file.

The generator also writes `chatgpt-desktop.theme` into each Workbench Omarchy
theme directory. Those files use ChatGPT Desktop's `codex-theme-v1:` import
format and can be pasted into **Settings → Appearance → Import theme** to
restore an individual variant through the UI.

Running `install-app-themes.py` places a copy of the tracked snippet at
`~/.config/codex-desktop/workbench-theme.toml`. This is a managed reference;
ChatGPT Desktop reads the merged values from `~/.codex/config.toml`.

General Codex Desktop settings are tracked separately in
`config/codex-desktop/settings.toml` and copied to
`~/.config/codex-desktop/settings.toml`. Merge those keys into the existing
`[desktop]` table in `~/.codex/config.toml`. In particular,
`projectlessWorkspaceRoot` points projectless tasks at
`/home/marchall/documents/codex`; without that override, Codex Desktop uses its
hard-coded `~/Documents/Codex` default instead of the XDG Documents directory.
