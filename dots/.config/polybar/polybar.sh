#!/usr/bin/env sh

killall -q polybar

for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	MONITOR=$monitor polybar --reload bar & disown
done
