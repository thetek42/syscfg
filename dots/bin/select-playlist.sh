#!/usr/bin/env sh
set -e

# query available playlists from mpd and sort them
playlists="$(mpc lsplaylists | sort)"
# ask user for a playlist using wmenu
playlist="$(echo "$playlists" | wmenu -i -f "Roboto Mono 10" -N 151515 -n bbbbbb -S 304f50 -s e1e1e1)"

# get list of songs in that playlist
songs="$(mpc -f "%track% %file%" playlist "$playlist")"

# if the playlist is an album, sort by the track number to play it in order
if [[ "$playlist" == "A: "* ]]; then
	songs="$(echo "$songs" | sort -n)"
fi

# extract file name from song list by stripping the initial album track number
files="$(echo "$songs" | cut -d ' ' -f 2-)"

# check if there is a queued song. if not, clear the queue to ensure that it
# isn't re-populated with the previously queued songs
is_song_queued="$(mpc queued)"
if [[ -z "$is_song_queued" ]]; then
	mpc clear
fi

# iterate through the file names and append every file to the mpd queue
# (note that the queue is not cleared before so that it is possible to queue
# multiple playlists)
echo "$files" | while IFS= read -r file; do
	mpc add "$file"
done

# if the playlist is not an album, shuffle it for random playback
if [[ "$playlist" == "P: "* ]]; then
	mpc shuffle
fi

# if there is no song currently playing, start playing the queue
currently_playing="$(mpc current)"
if [ -z "$currently_playing" ]; then
	mpc play
fi
