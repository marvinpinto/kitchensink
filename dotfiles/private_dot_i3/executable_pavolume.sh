#!/bin/bash

# Inspired by
# http://customlinux.blogspot.com/2013/02/pavolumesh-control-active-sink-volume.html
# and modified for my own needs.

inc='5'

active_sink=`pacmd list-sinks |awk '/\* index:/{print $3}'`
limit=$(expr 100 - ${inc})

function setMuteStatus {
  local muteStatus=$1
  local all_sinks=$(pacmd list-sinks |grep -i 'index:' |awk -F : '{print $2}')
  for sink in ${all_sinks}
  do
    pactl set-sink-mute ${sink} ${muteStatus}
  done
}

function volUp {
  getCurVol
  setMuteStatus 0

  if [[ ${curVol} -lt ${limit} ]]; then
    pactl set-sink-volume ${active_sink} "+${inc}%"
  else
    pactl set-sink-volume ${active_sink} "100%"
  fi

  getCurVol
}

function volDown {
  setMuteStatus 0
  pactl set-sink-volume ${active_sink} "-${inc}%"
  getCurVol
}

function volSync {
  getCurVol
  local all_sinks=$(pacmd list-sinks |grep -i 'index:' |awk -F : '{print $2}')

  for sink in ${all_sinks}
  do
    pactl set-sink-volume ${sink} "${curVol}%"
  done
}

function getCurVol {
  curVol=`pacmd list-sinks |grep -A 15 'index: '${active_sink}'' |grep 'volume:' |egrep -v 'base volume:' |awk -F : '{print $3}' |grep -o -P '.{0,3}%'|sed s/.$// |tr -d ' '`
}

function volMute {
  case "$1" in
    mute)
      setMuteStatus 1
      ;;
    unmute)
      setMuteStatus 0
      getCurVol
      volSync
      ;;
  esac
}

function volMuteStatus {
  curStatus=`pacmd list-sinks |grep -A 15 'index: '${active_sink}'' |awk '/muted/{ print $2}'`
  if [[ "${curStatus}" == "yes" ]]; then
    volMute unmute
  else
    volMute mute
  fi
}

case "$1" in
  --up)
    volUp
    ;;
  --down)
    volDown
    ;;
  --togmute)
    volMuteStatus
    ;;
  --mute)
    volMute mute
    ;;
  --unmute)
    volMute unmute
    ;;
  --sync)
    volSync
    ;;
esac
