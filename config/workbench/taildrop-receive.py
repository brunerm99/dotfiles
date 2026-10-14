#!/usr/bin/python3
"""Collect Taildrop files and reveal each arriving batch in one Nemo window."""

import argparse
import queue
import re
import subprocess
import threading
import time
from pathlib import Path

import gi

gi.require_version("Atspi", "2.0")
from gi.repository import Atspi, Gio, GLib


def children(node):
    return [node.get_child_at_index(i) for i in range(node.get_child_count())]


def walk(node):
    yield node
    if node.get_role() not in (Atspi.Role.MENU, Atspi.Role.MENU_BAR):
        for child in children(node):
            if child is not None:
                yield from walk(child)


def nemo_windows():
    return [window for app in children(Atspi.get_desktop(0))
            if app.get_name() == "nemo" for window in children(app)]


def select_batch(window, names):
    """Nemo 6.6 opens one window per ShowItems URI; use its selection API."""
    for view in walk(window):
        if "Selection" not in view.get_interfaces():
            continue
        if "Table" in view.get_interfaces():
            table = view.get_table_iface()
            rows = {}
            for row in range(table.get_n_rows()):
                cell = table.get_accessible_at(row, 0)
                for item in walk(cell):
                    if item.get_name() in names:
                        rows[item.get_name()] = row
            if rows.keys() >= names:
                view.get_selection_iface().clear_selection()
                for name in names:
                    table.add_row_selection(rows[name])
                return set(table.get_selected_rows()) == set(rows.values())
        elif view.get_role() == Atspi.Role.LAYERED_PANE:
            indices = {item.get_name(): i for i, item in enumerate(children(view))
                       if item.get_name() in names}
            if indices.keys() >= names:
                selection = view.get_selection_iface()
                selection.clear_selection()
                for name in names:
                    selection.select_child(indices[name])
                selected = {selection.get_selected_child(i).get_name()
                            for i in range(selection.get_n_selected_children())}
                return selected == names
    return False


def reveal(paths):
    paths = [path for path in paths if path.is_file()]
    if not paths:
        return
    before = set(nemo_windows()) if len(paths) > 1 else set()
    bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
    # Address Nemo explicitly, even if Dolphin owns FileManager1's bus name.
    # Nemo exports the interface shortly after its application is activated.
    deadline = time.monotonic() + 10
    while True:
        try:
            bus.call_sync(
                "org.Nemo", "/org/freedesktop/FileManager1",
                "org.freedesktop.FileManager1", "ShowItems",
                GLib.Variant("(ass)", ([paths[0].as_uri()], "")),
                None, Gio.DBusCallFlags.NONE, 5000, None,
            )
            break
        except GLib.Error as error:
            if ("UnknownMethod" not in str(error)
                    or time.monotonic() >= deadline):
                raise
            time.sleep(0.1)
    if len(paths) > 1:
        deadline = time.monotonic() + 10
        names = {path.name for path in paths}
        while time.monotonic() < deadline:
            for window in nemo_windows():
                if window not in before and window.get_name() == paths[0].parent.name:
                    if select_batch(window, names):
                        print(f"Selected {len(paths)} files in Nemo", flush=True)
                        return
            time.sleep(0.1)
        raise RuntimeError("Nemo opened, but could not select the complete batch")
    print("Selected 1 file in Nemo", flush=True)


def completed_path(line, destination):
    # Tailscale 1.104's verbose completion is emitted only after the file closes.
    # Taildrop rejects slashes/control characters in names. Do not split on
    # spaces, parentheses, or ' as ', which are all valid filename content.
    match = re.search(
        r"(?:^|waiting for file\.\.\.)wrote [^/]+ as ("
        + re.escape(str(destination)) + r"/[^/]+) \((\d+) bytes\)$", line,
    )
    if match:
        path = Path(match[1])
        if path.is_file() and path.stat().st_size == int(match[2]):
            return path
    return None


def receive(destination):
    destination.mkdir(parents=True, exist_ok=True, mode=0o700)
    process = subprocess.Popen(
        ["/usr/bin/tailscale", "file", "get", "--loop", "--verbose",
         "--conflict=rename", str(destination)],
        stdout=subprocess.PIPE, text=True, encoding="utf-8", bufsize=1,
    )
    lines = queue.Queue()

    def read_output():
        for line in process.stdout:
            lines.put(line.rstrip("\n"))
        lines.put(None)

    threading.Thread(target=read_output, daemon=True).start()
    pending = {}
    deadline = None
    try:
        while True:
            try:
                line = lines.get(timeout=max(0, deadline - time.monotonic())
                                 if deadline is not None else None)
            except queue.Empty:
                try:
                    reveal(list(pending))
                except Exception as error:
                    print(f"Could not reveal received files: {error}", flush=True)
                    # Keep the files queued if Nemo or the display is unavailable.
                    deadline = time.monotonic() + 10
                    continue
                pending.clear()
                deadline = None
                continue
            if line is None:
                raise RuntimeError(f"tailscale file get exited: {process.wait()}")
            print(line, flush=True)
            path = completed_path(line, destination)
            if path is not None:
                pending[path] = None
                deadline = time.monotonic() + 1.5
    finally:
        if process.poll() is None:
            process.terminate()
            process.wait(timeout=5)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    args = parser.parse_args()
    receive(args.directory.expanduser().resolve())
