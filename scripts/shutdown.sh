#!/bin/sh

cmd=$(printf "poweroff\nreboot\nsuspend\nlock\nkillX\n" | dmenu -p "Execute:" $*)

if [ -z "$cmd" ]; then
	exit 0
fi

case "$cmd" in
	poweroff)
		systemctl poweroff ;;
	reboot)
		systemctl reboot ;;
	suspend)
		systemctl suspend ;;
	lock)
		slock ;;
	killX)
		killall X ;;
	*)
		printf "Option not recognized: %s\n" "$cmd" >&2
esac