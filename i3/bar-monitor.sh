#!env /bin/bash
killall  polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# main polybar
polybar mainbar -c /home/tau/.config/polybar/config &

# sub polybar
hdmi=$(xrandr | grep 'HDMI1 connected')
if [ "$hdmi" != "" ]; then
    xrandr --output HDMI1 --auto --right-of eDP1
    polybar subbar -c /home/tau/.config/polybar/config &
else
    xrandr --output HDMI1 --off
fi
