"""Open images inspected by Codex CLI in feh."""

import json
import os
from pathlib import Path
import subprocess
import sys


def main():
    try:
        event = json.load(sys.stdin)
        if event.get("tool_name") != "view_image":
            return
        response = event.get("tool_response")
        if isinstance(response, dict) and response.get("isError"):
            return
        path = event.get("tool_input", {}).get("path")
        if not isinstance(path, str) or not path or not os.environ.get("DISPLAY"):
            return
        image = Path(path).expanduser()
        if not image.is_absolute():
            image = Path(event["cwd"]) / image
        if not image.is_file():
            return
        subprocess.Popen(
            ["feh", "--scale-down", "--", str(image)],
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )
    except (KeyError, OSError, TypeError, ValueError):
        # Image viewing in Codex should still succeed if feh is unavailable.
        return


if __name__ == "__main__":
    main()
