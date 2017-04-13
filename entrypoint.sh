#!/bin/bash
if [ ! -z $VNC_PASSWORD ];then
	mkdir -p ~/.vnc
	x11vnc -storepasswd $VNC_PASSWORD ~/.vnc/passwd
	unset VNC_PASSWORD
fi
export WINEPREFIX='/data/wine'
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
if [ ! -f ~/.vnc/passwd ];then  
	x11vnc -display $DISPLAY -xkb -forever -shared -nopw &
else
	x11vnc -display $DISPLAY -usepw -xkb -forever -shared -nopw &
fi
node /usr/lib/noVNC/websockify/websockify.js --web /usr/lib/noVNC/web 80 localhost:5900