#!/usr/bin/env sh

# what eebus uses for json:    [{"key1": value}, {"key2": value}, ...]
# what every sane person uses: {"key1": value, "key2": value, ...}
# this script converts from eebus-json to normal json.

input=""
while IFS= read -r line; do
	input+="$line"$'\n'
done

echo "$input" | sed 's/},{/,/g' | sed 's/\[{/{/g' | sed 's/}]/}/g'
