#!/usr/bin/env python3
"""Waybar power button: a small session menu driven by fuzzel."""
import shutil
import subprocess
import sys

ENTRIES = [
    ("Lock", "command -v hyprlock >/dev/null 2>&1 && exec hyprlock"),
    ("Log out", "hyprctl dispatch exit"),
    ("Suspend", "systemctl suspend"),
    ("Reboot", "systemctl reboot"),
    ("Shut down", "systemctl poweroff"),
]


def main() -> int:
    if not shutil.which("fuzzel"):
        print("fuzzel not found", file=sys.stderr)
        return 1

    menu = "\n".join(name for name, _ in ENTRIES) + "\n"
    result = subprocess.run(
        ["fuzzel", "--dmenu", "--prompt", "Session: "],
        input=menu,
        capture_output=True,
        text=True,
    )
    choice = result.stdout.strip()
    for name, command in ENTRIES:
        if name == choice:
            subprocess.Popen(["sh", "-c", command])
            break
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
