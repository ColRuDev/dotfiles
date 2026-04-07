#!/bin/bash

VIDEOS_DIR="/home/nickescolr/Vídeos/Wallpapers/"
MPV_OPTS="--hwdec=auto-safe --speed=0.6 --loop-file=2 --loop-playlist --shuffle --no-audio"

# Launch wallpaper in background with &
mpvpaper -o "$MPV_OPTS" "*" "$VIDEOS_DIR" &
MPV_PID=$!

while kill -0 $MPV_PID 2>/dev/null; do
    # Ask niri if the is a maximized window
    # Use my window size - if change or has multiple monitors this logic must be changed
    # niri msg outputs show all monitors information
    IS_MAXIMIZED=$(niri msg windows | grep "Window size: 1920 x 1080")
    echo "$IS_MAXIMIZED"

    if [ -n "$IS_MAXIMIZED" ]; then
        # Stop with (SIGSTOP)
        kill -STOP $MPV_PID 2>/dev/null
    else
        # Reproduce with (SIGCONT)
        kill -CONT $MPV_PID 2>/dev/null
    fi

    sleep 5
done
