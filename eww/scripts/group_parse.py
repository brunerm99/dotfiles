# group_parse.py

import sys
from libqtile.command.client import InteractiveCommandClient

c = InteractiveCommandClient()

group_info = c.groups()
active_groups = [k for k, v in group_info.items() if len(v["windows"]) > 0]
info = c.group.info()
current_group = info["name"]
active_groups.append(str(current_group))
active_groups = sorted(
    list(set(active_groups)),
    key=lambda x: int(x) if x != "0" else 9999,
)


if sys.argv[1] == "active":
    print(active_groups)
elif sys.argv[1] == "current":
    print(current_group)
elif sys.argv[1] == "yuck":
    GROUP_OUTPUT = """
    (box    :orientation "v"
            :valign "start"
            :spacing 15
            :halign "center"
        {inner_groups}
    )
    """

    INNER_GROUP = """
    (box    :orientation "v"
            :class "{classname}"
            :valign "start"
        (label :text "{name}"))
    """

    inner_groups = []
    for name in active_groups:
        if name == str(current_group):
            inner_groups.append(
                INNER_GROUP.format(name=name, classname="workspace-active")
            )
        else:
            inner_groups.append(INNER_GROUP.format(name=name, classname="workspace"))

    yuck_output = GROUP_OUTPUT.format(inner_groups=" ".join(inner_groups))
    print(yuck_output)
elif sys.argv[1] == "layout":
    pass
else:
    print("")
