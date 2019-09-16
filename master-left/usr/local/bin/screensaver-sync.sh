#!/bin/bash
#This script requires SSH with keys to work between this host and the slave
#Customize the user/IP address of the slave below.

SLAVE=odroid@192.168.228.22
XDG_RUNTIME_DIR=/run/user/1000
STATE=inactive

while :
do
	#Get screensaver lock status
	DISPLAY=:0 mate-screensaver-command -q | grep "is active"
	if [ "$?" -eq "0" ]; then
		if [ "$STATE" == "inactive" ]; then
			logger -s -t "$0" "Screensaver turned active. Turning off slave screen"
			ssh $SLAVE DISPLAY=:0 xset dpms force off
			STATE=active
		fi
	else
		if [ "$STATE" == "active" ]; then
			logger -s -t "$0" "Screensaver turned inactive. Turning on slave screen"
			ssh $SLAVE DISPLAY=:0 xset dpms force on
			STATE=inactive
		fi
	fi
	
	sleep 2
done
