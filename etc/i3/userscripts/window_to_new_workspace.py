#!/usr/bin/env python
# -*- coding: utf-8 -*-

import subprocess
import sys
import i3ipc


def send_notify(title, msg, msg_type):
    subprocess.run(["notify-send", "-u", msg_type, title, msg])


if __name__ == "__main__":
    i3 = i3ipc.Connection()

    focused = i3.get_tree().find_focused()
    if len(focused.workspace().descendents()) == 0:
        # no children to move
        sys.exit(0)

    spaces = i3.get_workspaces()
    new_num = 1
    space_nums = []
    for space in spaces:
        space_nums.append(space.num)
    wrapped = False

    while new_num in space_nums:
        new_num += 1
        if new_num > 10:
            if wrapped:
                send_notify("Workspace move failed", "No free workspace left", "normal")
                sys.exit(0)
            new_num = 1
            wrapped = True

    i3.command('move window to workspace {}'.format(new_num))
    send_notify("New workspace {}".format(new_num), focused.name, "normal")
