#!/usr/bin/env bash

SLEEP_DURATION=.5
WORKSPACE_NAME=$(zenity --title="New Dev Workspace" --text="Workspace Name:" --entry)
if [ -z "$WORKSPACE_NAME" ]; then
  zenity --error --text="This script needs a workspace name to function correctly"
  exit 1
fi

exists=$(i3-msg -t get_workspaces | jq '.[] | select(.name == "${WORKSPACE_NAME}")')
if [ -n "$exists" ]; then
  zenity --error --text="Workspace $WORKSPACE_NAME already exists"
  exit 1
fi

notify-send -i info -u normal -t 1000 -- 'Generating dev window layout'
i3-msg "workspace ${WORKSPACE_NAME};"
sleep ${SLEEP_DURATION}
i3-msg 'append_layout ~/.i3/dev-layout.json'

for i in {1..4}
do
  sleep ${SLEEP_DURATION}
  i3-msg exec "gnome-terminal --working-directory=${HOME}/projects/${WORKSPACE_NAME}"
  sleep ${SLEEP_DURATION}
  xdotool type "sink ${WORKSPACE_NAME}"
  xdotool key KP_Enter
  sleep 3
  xdotool type "clear"
  xdotool key KP_Enter
  sleep ${SLEEP_DURATION}
done

i3-msg exec "gnome-terminal --working-directory=${HOME}/projects/${WORKSPACE_NAME}"
sleep ${SLEEP_DURATION}
xdotool type "clear"
xdotool key KP_Enter
sleep ${SLEEP_DURATION}

notify-send -i info -u normal -t 5000 -- 'Layout generation complete'
