#!/bin/bash

if pgrep -x thunderbird >/dev/null; then
  thunderbird &
else
  thunderbird &
  sleep 3
  kdocker -q -x "$(pgrep -x -n thunderbird)" &
fi
