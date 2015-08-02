#!/bin/bash

export PATH=/bin:/usr/bin:/usr/local/bin

urxvtd -q -o &
gnome-screensaver &
volumeicon &
compton -fcC -r 10 -D 5 -z &
dropbox start &
conky -p 2 &
devilspie -a &
gnome-settings-daemon &
exec gpg-agent --daemon herbstluftwm
