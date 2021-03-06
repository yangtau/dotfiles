#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
# Launch sub polybar
polybar subbar -c /home/tau/.config/polybar/config & 
# Launch main polybar
polybar mainbar -c /home/tau/.config/polybar/config &

