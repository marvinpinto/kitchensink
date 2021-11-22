#!/bin/bash

set -o pipefail

SYSLOG_TAG="startup-app"
app_command=$1
process_regex=$2

info() {
  /usr/bin/logger --id --priority local3.info --tag $SYSLOG_TAG "INFO: $@"
}

if [ -z "$process_regex" ]; then
  process_regex=$app_command
fi

info "Searching for all processes matching ${process_regex}"
pids=( $(pgrep -f "$process_regex") )
for pid in "${pids[@]}"; do
  if [[ $pid != $$ ]]; then
    info "Force-stopping process ${pid}"
    kill -9 "$pid" > /dev/null 2>&1
  fi
done

info "Attempting to execute: ${app_command}"
eval $app_command 2>&1 | /usr/bin/logger --id --priority 'local3.info' --tag "${SYSLOG_TAG}" &
info "Startup script complete."
