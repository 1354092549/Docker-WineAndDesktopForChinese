#!/bin/bash
export DISPLAY=':1'
Xvfb $DISPLAY -screen 0 1024x768x16 &
for i in $(seq 1 10); do
	xdpyinfo -display $DISPLAY >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		break
	fi
	echo Waiting xvfb...
	sleep 0.5
done
jwm &
xterm &
x11vnc -display $DISPLAY -xkb -forever -shared -nopw &
node /usr/lib/noVNC/websockify/websockify.js --web /usr/lib/noVNC/web 80 localhost:5900