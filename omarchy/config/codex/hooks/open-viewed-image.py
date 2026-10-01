"""Give Codex CLI a clickable file URL after it views a local image."""

import json
from pathlib import Path
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
        if not isinstance(path, str) or not path:
            return
        image = Path(path).expanduser()
        if not image.is_absolute():
            image = Path(event["cwd"]) / image
        if not image.is_file():
            return
        print(json.dumps({"systemMessage": f"Open viewed image: {image.resolve().as_uri()}"}))
    except (KeyError, OSError, TypeError, ValueError):
        return


if __name__ == "__main__":
    main()
