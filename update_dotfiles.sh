#!/usr/bin/env sh
set -e

mkdir -p "$HOME/bin"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/Signal"
mkdir -p "$HOME/.local/share/mpd"
mkdir -p "$HOME/.mozilla/firefox/myprofile"
rm -f "$HOME/.mozilla/firefox/myprofile/search.json.mozlz4"
stow -R -t "$HOME" dots
