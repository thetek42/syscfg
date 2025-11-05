#!/usr/bin/env sh
set -e

for file in *.mp3; do
	if ! id3info -- "$file" | grep -q "TIT2"; then
		echo "$file"
	fi
done
