#!/bin/bash

# start the SSH agent and save the env info to a file
sshinfo="${HOME}/.ssh/ssh-agent-info"
rm -f "$sshinfo"
killall -q ssh-agent || true
ssh-agent -s > $sshinfo
sed -i '/^echo Agent/d' $sshinfo
