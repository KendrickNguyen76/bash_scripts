#!/bin/bash

# notes.sh

# Run this file to set up the terminal for note taking!

# Grab folder name from user if provided
folder=$1

# If the folder = EXIT, close down the session
if [ "$folder" == "EXIT" ]
then
    # Create new session
    tmux new-session -d -s "notes-exit"

    # Switch to the new session
    tmux switch-client -t "notes-exit"

    # Close working environment
    tmux kill-session -t "notes"
fi

# Rename the current session to "notes"
tmux rename-session "notes"

# Set up vim window for note-taking
tmux rename-window "editor"
tmux send-keys -t "editor" "clear" C-m
tmux send-keys -t "editor" "notes new $folder" C-m

# Set up terminal window for display
tmux new-window -d -c "/Users/kendrick/Documents/notes" -n "display"
