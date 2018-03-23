 #! /usr/bin/env sh
 WALLPAPERS="/home/mindaugas/wallpapers"

 desktop_bg=$(find "$WALLPAPERS" -type f | shuf | head -n 1) &&
 exec feh --bg-scale "$desktop_bg"
