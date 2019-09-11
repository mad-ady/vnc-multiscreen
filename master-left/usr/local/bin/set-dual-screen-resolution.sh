#!/bin/bash
sleep 5
logger -s -t "$0" "Setting lightdm dual-screen resolution"
DISPLAY=:0 xrandr --output HDMI-1 --fb 3360x1050 --panning 1680x1050
