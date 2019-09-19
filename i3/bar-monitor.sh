#!env /bin/bash
second_monitor="HDMI-1"
primary_monitor="eDP-1"

killall  polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# main polybar
polybar mainbar -c /home/tau/.config/polybar/config &

# sub polybar
hdmi=$(xrandr | grep "$second_monitor connected")
if [ "$hdmi" != "" ]; then
    xrandr --output "$second_monitor" --auto --right-of "$primary_monitor"
    polybar subbar -c /home/tau/.config/polybar/config &
else
    xrandr --output "$second_monitor" --off
fi
