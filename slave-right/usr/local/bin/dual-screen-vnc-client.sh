#!/bin/bash
MASTER=192.168.228.203

#override here with the total X*Y resolution to bypass detection. 
#detection assumes you're running 2 displays of identical resolution
#side-by-side

TOTALWIDTH=
TOTALHEIGHT=

if [ -z "$TOTALWIDTH" ]; then
	XRESOLUTION=`DISPLAY=:0 xdotool getdisplaygeometry | cut -d " " -f 1`
	TOTALWIDTH=`echo $XRESOLUTION*2 | bc`
	logger -s -t "$0" "Calculated total width $TOTALWIDTH"
fi
if [ -z "$TOTALHEIGHT" ]; then
	YRESOLUTION=`DISPLAY=:0 xdotool getdisplaygeometry | cut -d " " -f 2`
	TOTALHEIGHT=$YRESOLUTION
	logger -s -t "$0" "Calculated total height $TOTALHEIGHT"
fi

logger -s -t "$0" "Starting local X server"

sleep 3

#turn off monitor energy saving features
DISPLAY=:0 xset -dpms
DISPLAY=:0 xset s off

#start the window positioning script
/usr/local/bin/window-positioning.sh &

#do this forever so that if the network disconnects, the session is rejoined.
while :
do
        logger -s -t "$0" "Starting vnc client"
	DISPLAY=:0 vncviewer -geometry ${TOTALWIDTH}x${TOTALHEIGHT} -compresslevel 0 -quality 9 -passwd /home/odroid/.vnc/passwd $MASTER
done

