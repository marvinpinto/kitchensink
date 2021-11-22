#!/usr/bin/env bash
set -e

full_name=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name')
new_name=$(printf "\n${name}" | rofi -dmenu -b -p "Rename workspace ${full_name} to")
i3-msg "rename workspace to \"${new_name}\""
