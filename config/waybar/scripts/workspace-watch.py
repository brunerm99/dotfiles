#!/usr/bin/env python3
import json
import os
import fcntl
import socket
import subprocess
import time


MAX_WORKSPACE = 20
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


def acquire_lock():
    lock = open(f"/tmp/waybar-workspace-watch-{os.getuid()}.lock", "w", encoding="utf-8")
    try:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        lock.close()
        return None

    lock.seek(0)
    lock.truncate()
    lock.write(f"{os.getpid()}\n")
    lock.flush()
    return lock


def active_workspace_id():
    try:
        return hypr_json("activeworkspace").get("id")
    except Exception:
        return None


def workspace_ids():
    try:
        ids = [ws.get("id") for ws in hypr_json("workspaces")]
    except Exception:
        return []
    return sorted(i for i in ids if isinstance(i, int) and 1 <= i <= MAX_WORKSPACE)


def clients_by_address():
    try:
        clients = hypr_json("clients")
    except Exception:
        return {}

    result = {}
    for client in clients:
        address = str(client.get("address", "")).lower()
        workspace = client.get("workspace") or {}
        workspace_id = workspace.get("id")
        if not address or not isinstance(workspace_id, int):
            continue
        result[address] = {
            "workspace": workspace_id,
            "title": client.get("title", ""),
            "class": client.get("class", ""),
        }
    return result


def load_dirty():
    try:
        with open(state_path(), "r", encoding="utf-8") as f:
            data = json.load(f)
        return set(int(ws) for ws in data.get("dirty", []))
    except Exception:
        return set()


def write_state(active, workspaces, dirty):
    active_dirty = set(dirty)
    if isinstance(active, int):
        active_dirty.discard(active)

    visible = set(workspaces)
    dirty_sorted = sorted(ws for ws in active_dirty if 1 <= ws <= MAX_WORKSPACE)
    data = {
        "active": active,
        "workspaces": sorted(visible | set(dirty_sorted)),
        "dirty": dirty_sorted,
    }

    path = state_path()
    tmp = f"{path}.tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, separators=(",", ":"))
    os.replace(tmp, path)


def signal_waybar():
    subprocess.run(
        ["pkill", "-RTMIN+9", "waybar"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )


def parse_workspace_name(value):
    if not value:
        return None
    value = value.strip()
    try:
        return int(value)
    except ValueError:
        return None


def normalize_window_address(value):
    if not value:
        return None
    return str(value).strip().lower().removeprefix("0x") or None


def active_window_address():
    try:
        return normalize_window_address(hypr_json("activewindow").get("address"))
    except Exception:
        return None


def socket_path():
    runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    instance = instance_signature()
    if not instance:
        return None
    return os.path.join(runtime, "hypr", instance, ".socket2.sock")


def main():
    lock = acquire_lock()
    if lock is None:
        return 0

    dirty = load_dirty()
    clients = clients_by_address()
    active = active_workspace_id()
    active_address = active_window_address()
    workspaces = workspace_ids()
    write_state(active, workspaces, dirty)
    signal_waybar()

    while True:
        path = socket_path()
        if not path:
            time.sleep(1)
            continue

        try:
            with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
                sock.connect(path)
                with sock.makefile("r", encoding="utf-8", errors="replace") as stream:
                    for raw_line in stream:
                        line = raw_line.strip()
                        if not line or ">>" not in line:
                            continue

                        event, payload = line.split(">>", 1)
                        changed = False

                        if event in {"workspace", "focusedmon"}:
                            active = active_workspace_id()
                            workspaces = workspace_ids()
                            if isinstance(active, int) and active in dirty:
                                dirty.discard(active)
                            changed = True

                        elif event == "activewindowv2":
                            # Hyprland can emit active-window events for title-only
                            # updates. Only refresh when keyboard focus actually moves.
                            address = normalize_window_address(payload)
                            if address != active_address:
                                active_address = address
                                changed = True

                        elif event in {"togglegroup", "moveintogroup", "moveoutofgroup"}:
                            changed = True

                        elif event in {"openwindow", "movewindow"}:
                            parts = payload.split(",", 3)
                            if len(parts) >= 2:
                                workspace = parse_workspace_name(parts[1])
                                if isinstance(workspace, int) and workspace != active:
                                    dirty.add(workspace)
                                    changed = True
                            clients = clients_by_address()
                            workspaces = workspace_ids()

                        elif event in {"windowtitle", "windowtitlev2"}:
                            address = payload.split(",", 1)[0].lower()
                            refreshed = clients_by_address()
                            client = refreshed.get(address)
                            previous = clients.get(address, {})
                            if client and client.get("title") != previous.get("title"):
                                workspace = client.get("workspace")
                                if isinstance(workspace, int) and workspace != active:
                                    dirty.add(workspace)
                                    changed = True
                            clients = refreshed
                            workspaces = workspace_ids()

                        elif event in {"urgent", "urgentwindow"}:
                            address = payload.split(",", 1)[0].lower()
                            clients = clients_by_address()
                            client = clients.get(address)
                            if client:
                                workspace = client.get("workspace")
                                if isinstance(workspace, int) and workspace != active:
                                    dirty.add(workspace)
                                    changed = True

                        elif event in {"closewindow", "destroyworkspace", "createworkspace"}:
                            clients = clients_by_address()
                            workspaces = workspace_ids()
                            changed = True

                        if changed:
                            write_state(active, workspaces, dirty)
                            signal_waybar()

        except Exception:
            time.sleep(1)


if __name__ == "__main__":
    raise SystemExit(main())
