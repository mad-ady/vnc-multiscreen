#!/bin/bash

#the master monitor's width and height resolution
WIDTH=
HEIGHT=

#otherwise, WIDTH and HEIGHT are assumed to be the same for both monitors

if [ -z "$WIDTH" ]; then
	XRESOLUTION=`DISPLAY=:0 xdotool getdisplaygeometry | cut -d " " -f 1`
	WIDTH=$XRESOLUTION
	logger -s -t "$0" "Assuming master monitor width $WIDTH"
fi
if [ -z "$HEIGHT" ]; then
	YRESOLUTION=`DISPLAY=:0 xdotool getdisplaygeometry | cut -d " " -f 2`
	HEIGHT=$YRESOLUTION
	logger -s -t "$0" "Assuming master monitor height $HEIGHT"
fi


while [ : ]
do
    logger -s -t "$0" "Looking for vnc client window"
    ACTIVEWIN=`DISPLAY=:0 xdotool search --onlyvisible --class vnc | tail -1`
    if [ -n "$ACTIVEWIN" ]; then
	 logger -s -t "$0" "Found the VNC window $ACTIVEWIN"
    	 
	 #shift the VNC window to the left (negative) by $WIDTH pixels

         DISPLAY=:0 xdotool windowmove $ACTIVEWIN "-$WIDTH" "0"
         if [ "$?" -eq "0" ]; then
         	logger -s -t "$0" "Positioned desktop to final position"
        	exit;
    	 else
        	logger -s -t "$0" "Looking for active window ($ACTIVEWIN)..."
        	sleep 1;
    	fi
    else
	sleep 1;
    fi
done
