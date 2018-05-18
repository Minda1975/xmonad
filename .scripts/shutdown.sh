#!/bin/sh

cmd=$(printf "poweroff\nreboot\nlock\n" | dmenu -p "Execute:" $* -b -nb '#002b36' -nf '#657b83' -sb '#002b36' -sf '#268bd2' -fn Sans)

if [ -z "$cmd" ]; then
	exit 0
fi

case "$cmd" in
	poweroff)
		systemctl poweroff ;;
	reboot)
		systemctl reboot ;;
	lock)
		slock ;;
	*)
		printf "Option not recognized: %s\n" "$cmd" >&2
esac
