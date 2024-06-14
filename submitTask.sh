#!/bin/bash

# Function to handle mentee submissions
handle_mentee_submission() {
  read -p "Enter task number (1, 2, or 3): " task_number
  read -p "Enter domain (web, app, or sysad): " domain

  # Check if task directory exists
  task_dir="/home/$USER/$domain/task$task_number"
  if [[ ! -d "$task_dir" ]]; then
    mkdir -p "$task_dir"
  fi

  read -p "Enter the task details: " task_details
  echo "$task_details" > "$task_dir/details.txt"

  # Update task_submitted.txt
  echo "Task $task_number submitted for $domain by $USER" >> "$HOME/task_submitted.txt"
}

# Function to handle mentor submissions
handle_mentor_submission() {
  mentor_name=$(basename "$HOME")
  mentor_domain=$(basename "$(dirname "$HOME")")

  # Iterate through all mentees
  for mentee_home in /home/core/mentees/*; do
    mentee_name=$(basename "$mentee_home")

    # Check if task directories exist and create symlinks
    for task_number in 1 2 3; do
      task_dir="$mentee_home/$mentor_domain/task$task_number"
      mentor_task_dir="$HOME/task$task_number"

      if [[ -d "$task_dir" && -n "$(ls -A "$task_dir")" ]]; then
        # Update task_completed.txt
        echo "Task $task_number completed by $mentee_name" >> "$HOME/task_completed.txt"
        # Create symlink if it does not exist
        if [[ ! -L "$mentor_task_dir/$mentee_name" ]]; then
          mkdir -p "$mentor_task_dir"
          ln -s "$task_dir" "$mentor_task_dir/$mentee_name"
        fi
      fi
    done
  done
}

# Determine user's role based on directory location
if [[ $PWD == /home/core/mentees/* ]]; then
  handle_mentee_submission
elif [[ $PWD == /home/core/mentors/* ]]; then
  handle_mentor_submission
else
  echo "Error: Unknown user type"
  exit 1
fi