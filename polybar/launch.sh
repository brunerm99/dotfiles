#!/usr/bin/env bash

# Terminate already running bar instances
polybar-msg cmd quit

# Launch bar on all screens
if type "xrandr"; then
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		MONITOR=$m polybar --reload mybar &
	done
else
	polybar --reload mybar &
fi

echo "Bars launched..."
