#!/usr/bin/env bash
# Set wallpaper + regenerate the whole palette with iris + refresh waybar.
# Usage: setwall.sh /path/to/wallpaper.jpg [--dark 1|0]

WALL="${1:?usage: setwall.sh <wallpaper> [--dark 1|0]}"
shift

# generate palette from the wallpaper (extra args like --dark 1 are passed through)
iris "$WALL" "$@"

# iris writes to ~/.cache/iris/ — if your waybar build doesn't expand "~"
# in CSS @import, keep this symlink and use @import "colors.css"; instead
ln -sf "$HOME/.cache/iris/colors-waybar.css" "$HOME/.config/waybar/colors.css"

# apply the wallpaper on MangoWM (pick one; iris does NOT set the wallpaper itself)
# swww img "$WALL" --transition-type grow --transition-pos 0.5,0.5 &
swaybg -i "$WALL" -m fill &

# hot-reload waybar styling
killall -SIGUSR2 waybar

# refresh swaync colors too, if you theme it with iris
# swaync-client -rs
