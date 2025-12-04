#!/usr/bin/env sh
set -e

# get list of songs in that playlist
songs="$(mpc -f "%disc%-%track% %title%" playlist "$1")"

# if the playlist is an album, sort by the track number to play it in order
if [[ "$1" == "A: "* ]]; then
	songs="$(echo "$songs" | sort -t - -k 1n -k 2n)"
else
	# for playlists, strip the disc and track number
	songs="$(echo "$songs" | cut -d ' ' -f 3-)"
fi


echo "$songs"
