#!/usr/bin/env python3
import json
import subprocess
import sys


BUTTONS = {
    "next": "↑",
    "prev": "↓",
}


def emit(payload):
    print(json.dumps(payload, separators=(",", ":")))


def active_window_is_grouped():
    try:
        output = subprocess.check_output(
            ["hyprctl", "-j", "activewindow"],
            text=True,
            stderr=subprocess.DEVNULL,
        )
        active_window = json.loads(output)
    except (OSError, subprocess.SubprocessError, json.JSONDecodeError):
        return False

    return len(active_window.get("grouped") or []) > 1


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in BUTTONS:
        emit({"text": "", "class": ["group-nav-button", "hidden"]})
        return 1

    if not active_window_is_grouped():
        emit(
            {
                "text": "",
                "class": ["group-nav-button", "hidden"],
                "tooltip": "",
            }
        )
        return 0

    direction = sys.argv[1]
    text = BUTTONS[direction]
    emit(
        {
            "text": text,
            "class": ["group-nav-button", direction],
        }
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
