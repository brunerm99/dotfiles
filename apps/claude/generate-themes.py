#!/usr/bin/env python3
"""Generate the Claude Code Workbench themes from the shared light/dark palettes.

Claude Code reads custom themes from ~/.claude/themes/<slug>.json. Each file
names a built-in base theme and overrides its color tokens; the token names come
from Claude Code's own palette (see `code.claude.com/docs/en/terminal-config`).
"""

import json
from pathlib import Path

HERE = Path(__file__).resolve().parent

PALETTES = {
    "light": {
        "background": "#e8e0d8", "surface": "#ffffff", "alt": "#f0ebe6",
        "foreground": "#243239", "muted": "#46585e", "border": "#c1c0bc",
        "accent": "#f07828", "orange_text": "#914312",
        # Text colors need the darker terminal variants on the light background.
        "text": {"red": "#9f332e", "green": "#176032", "yellow": "#774917",
                 "blue": "#195b7a", "purple": "#694497", "cyan": "#205b6c"},
        # Mid-tones tint diff backgrounds.
        "tint": {"red": "#d94840", "green": "#2ca65a"},
        "message": "#f0ebe6", "message_hover": "#ffffff", "panel": "#ffffff",
    },
    "dark": {
        "background": "#1e2c31", "surface": "#283a40", "alt": "#2d3e44",
        "foreground": "#d4d0cc", "muted": "#8fa3ab", "border": "#3d5058",
        "accent": "#f07828", "orange_text": "#f09050",
        "text": {"red": "#fc6255", "green": "#44d47a", "yellow": "#e0a050",
                 "blue": "#58c4dd", "purple": "#a87edb", "cyan": "#50dbc8"},
        "tint": {"red": "#fc6255", "green": "#44d47a"},
        "message": "#283a40", "message_hover": "#2d3e44", "panel": "#2d3e44",
    },
}

# Built-in bases keep Claude Code's colorblind-friendly defaults for any token
# that a future release adds and this file does not know about yet.
BASES = {"light": "light-daltonized", "dark": "dark-daltonized"}


def rgb(color):
    return tuple(int(color[i:i + 2], 16) for i in (1, 3, 5))


def blend(start, end, amount):
    return "#" + "".join(f"{round(a + (b - a) * amount):02x}" for a, b in zip(rgb(start), rgb(end)))


def lighten(color):
    return blend(color, "#ffffff", 0.35)


def overrides(mode):
    p = PALETTES[mode]
    t = p["text"]
    claude = p["accent"] if mode == "dark" else p["orange_text"]
    pink = blend(t["red"], t["purple"], 0.5)
    colors = {
        "claude": claude, "claudeShimmer": lighten(claude),
        "claudeBlue_FOR_SYSTEM_SPINNER": t["blue"], "claudeBlueShimmer_FOR_SYSTEM_SPINNER": lighten(t["blue"]),
        "text": p["foreground"], "inverseText": p["background"],
        "inactive": p["muted"], "inactiveShimmer": blend(p["muted"], p["foreground"], 0.5),
        "subtle": p["border"],
        "promptBorder": p["border"], "promptBorderShimmer": p["muted"],
        "permission": t["blue"], "permissionShimmer": lighten(t["blue"]),
        "suggestion": t["blue"], "remember": t["blue"], "ide": t["blue"],
        "planMode": t["cyan"], "background": t["cyan"],
        "autoAccept": t["purple"], "autoAcceptShimmer": lighten(t["purple"]),
        "skill": t["purple"], "merged": t["purple"], "effortUltra": t["purple"], "bashBorder": t["purple"],
        "success": t["green"], "error": t["red"],
        "warning": t["yellow"], "warningShimmer": lighten(t["yellow"]),
        "diffAdded": blend(p["background"], p["tint"]["green"], 0.30),
        "diffRemoved": blend(p["background"], p["tint"]["red"], 0.30),
        "diffAddedDimmed": blend(p["background"], p["tint"]["green"], 0.15),
        "diffRemovedDimmed": blend(p["background"], p["tint"]["red"], 0.15),
        "diffAddedWord": blend(p["background"], p["tint"]["green"], 0.50),
        "diffRemovedWord": blend(p["background"], p["tint"]["red"], 0.50),
        "red_FOR_SUBAGENTS_ONLY": t["red"], "blue_FOR_SUBAGENTS_ONLY": t["blue"],
        "green_FOR_SUBAGENTS_ONLY": t["green"], "yellow_FOR_SUBAGENTS_ONLY": t["yellow"],
        "purple_FOR_SUBAGENTS_ONLY": t["purple"], "orange_FOR_SUBAGENTS_ONLY": claude,
        "pink_FOR_SUBAGENTS_ONLY": pink, "cyan_FOR_SUBAGENTS_ONLY": t["cyan"],
        "professionalBlue": t["blue"], "chromeYellow": t["yellow"],
        "clawd_body": claude, "clawd_background": p["background"],
        "userMessageBackground": p["message"], "userMessageBackgroundHover": p["message_hover"],
        "composerSidebarBackground": p["panel"], "selectionBg": p["border"],
        "bashMessageBackgroundColor": p["panel"], "memoryBackgroundColor": p["message"],
        "rate_limit_fill": t["blue"], "rate_limit_empty": p["border"],
        "fastMode": claude, "fastModeShimmer": lighten(claude),
        "briefLabelYou": t["blue"], "briefLabelClaude": claude,
    }
    rainbow = {"red": t["red"], "orange": claude, "yellow": t["yellow"], "green": t["green"],
               "blue": t["blue"], "indigo": t["purple"], "violet": pink}
    for name, color in rainbow.items():
        colors[f"rainbow_{name}"] = color
        colors[f"rainbow_{name}_shimmer"] = lighten(color)
    return colors


def main():
    for mode in PALETTES:
        theme = {"name": f"Workbench {mode.capitalize()}", "base": BASES[mode], "overrides": overrides(mode)}
        path = HERE / "themes" / f"workbench-{mode}.json"
        path.write_text(json.dumps(theme, indent=2) + "\n")
        print(f"wrote {path.relative_to(HERE.parent.parent)} ({len(theme['overrides'])} tokens)")


if __name__ == "__main__":
    main()
