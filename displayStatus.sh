#!/bin/bash

# Defining file paths
MENTEE_DETAILS="sysad-task1-menteeDetails.txt"
TASK_SUBMITTED_DIR="/home/$USER/task_submitted"
TASK_SUBMITTED="$TASK_SUBMITTED_DIR/task_submitted.txt"
TMP_LOG="/tmp/displayStatus.log"

# Function to calculate total percentage of submissions
calculate_percentage() {
  local total=$(wc -l < "$MENTEE_DETAILS")
  local submitted=$(wc -l < "$TASK_SUBMITTED")
  if [[ $total -eq 0 ]]; then
    echo "Error: No mentee details found."
    exit 1
  fi
  local percentage=$(awk "BEGIN {printf \"%.2f\", ($submitted / $total) * 100}")
  echo "$percentage%"
}

# Function to get unique recent submissions (since last call)
get_recent_submissions() {
  # Check if a temporary file exists for tracking
  if [[ ! -f "$TMP_LOG" ]]; then
    touch "$TMP_LOG" || { echo "Error: Failed to create temporary log file."; exit 1; }
  fi

  # Diff between current and previous state (considering only task details)
  comm -13 <(sort "$TMP_LOG") <(sort "$TASK_SUBMITTED")
}

# Function to filter submissions by domain
filter_by_domain() {
  local domain=$1
  grep "Task .* submitted for $domain by " "$TASK_SUBMITTED"
}

# Actual main function to display status
display_status() {
  local domain=$1

  echo "Total Percentage of Submissions: $(calculate_percentage)"
  echo "List of Mentees who recently submitted the task:"

  # Getting recent submissions (considering only task details)
  recent_submissions=$(get_recent_submissions)

  if [[ -z $domain ]]; then
    echo "$recent_submissions"
  else
    echo "$recent_submissions" | grep "$domain"
  fi

  # Updating temporary file for next call
  cp "$TASK_SUBMITTED" "$TMP_LOG" || { echo "Error: Failed to update temporary log file."; exit 1; }
}

# Checking if domain argument is provided
if [[ $# -eq 1 ]]; then
  display_status "$1"
else
  display_status
fi