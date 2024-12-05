#!/usr/bin/env sh

killall -q polybar
polybar bar & disown

for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	MONITOR=$monitor polybar --reload bar & disown
done
