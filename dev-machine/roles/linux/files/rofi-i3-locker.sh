#!/usr/bin/env bash

LOCKFILE="/tmp/i3lock-lockfile.txt"
PROG=`basename "$0"`

revert() {
  xset dpms 0 0 0
  rm -f ${LOCKFILE}
}

if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
  msg="${PROG} already running"
  echo $msg
  logger -t i3lock $msg
  exit
fi

# make sure the lockfile is removed when we exit and then claim it
trap revert SIGHUP SIGINT SIGTERM

# echo our PID into the lockfile
echo $$ > ${LOCKFILE}

xset +dpms dpms 5 5 5
/usr/bin/i3lock --color=00001A --nofork
revert
