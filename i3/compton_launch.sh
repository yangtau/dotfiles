#!env /bin/bash
killall compton
killall picom

while pgrep -u $UID -x compton >/dev/null; do sleep 1; done

picom > /dev/null 2>&1 &
