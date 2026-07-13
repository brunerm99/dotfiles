#!/usr/bin/env python3
import json
import glob
import os
import subprocess
import sys


INSTANCE = None


def hypr_json(command):
    return json.loads(subprocess.check_output(["hyprctl", "-j", command], text=True))


def instance_signature():
    global INSTANCE
    if INSTANCE:
        return INSTANCE

    INSTANCE = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if INSTANCE:
        return INSTANCE

    try:
        instances = hypr_json("instances")
    except Exception:
        instances = []

    for instance in instances:
        signature = instance.get("instance")
        if signature:
            INSTANCE = signature
            return INSTANCE

    return None


def state_path():
    uid = os.getuid()
    instance = instance_signature() or "default"
    return f"/tmp/waybar-workspaces-{uid}-{instance}.json"


def state_paths():
    uid = os.getuid()
    paths = [state_path()]
    paths.extend(
        sorted(
            glob.glob(f"/tmp/waybar-workspaces-{uid}-*.json"),
            key=os.path.getmtime,
            reverse=True,
        )
    )

    seen = set()
    for path in paths:
        if path in seen:
            continue
        seen.add(path)
        yield path


def fallback_state():
    try:
        active = hypr_json("activeworkspace").get("id")
        workspaces = hypr_json("workspaces")
    except Exception:
        return {"active": None, "workspaces": [], "dirty": []}

    return {
        "active": active,
        "workspaces": sorted(
            ws.get("id") for ws in workspaces if isinstance(ws.get("id"), int)
        ),
        "dirty": [],
    }


def read_state():
    for path in state_paths():
        try:
            with open(path, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            continue
    return fallback_state()


def emit(payload):
    print(json.dumps(payload, separators=(",", ":")))


def main():
    if len(sys.argv) != 2:
        emit({"text": "", "class": ["workspace-button", "empty"]})
        return 1

    workspace = int(sys.argv[1])
    state = read_state()
    workspaces = set(state.get("workspaces", []))
    dirty = set(state.get("dirty", []))
    active = state.get("active")

    if workspace not in workspaces and workspace not in dirty:
        emit({"text": "", "class": ["workspace-button", "empty"]})
        return 0

    classes = ["workspace-button"]
    if workspace == active:
        text = str(workspace)
        classes.append("active")
    else:
        text = str(workspace)
        if workspace in dirty:
            classes.append("needs-attention")

    emit(
        {
            "text": text,
            "class": classes,
        }
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
