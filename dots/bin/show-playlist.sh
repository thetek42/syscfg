#!/usr/bin/env sh
set -e

if [[ "$1" == "A: "* ]]; then
	# if the playlist is an album, sort by the track number
	# prepent 0 because some songs have an empty disc number
	songs="$(mpc -f "0%disc%-%track% %title%" playlist "$1")"
	songs="$(echo "$songs" | sort -t - -k 1n -k 2n)"
else
	# if the playlist is a playlist, show titles and sort alphabetically
	songs="$(mpc -f "%title%" playlist "$1")"
	songs="$(echo "$songs" | sort)"
fi

echo "$songs"
