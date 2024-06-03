#!/bin/bash

# Define file paths
MENTEE_DETAILS="sysad-task1-menteeDetails.txt"
DOMAIN_PREF="domain_pref.txt"

# Function to remove mentee completely
remove_mentee_completely() {
  local mentee_home=$1
  rm -rf "$mentee_home"
}

# Function to check and clean up deregistered mentees
cleanup_deregistered() {
  # Iterate through all mentees
  for mentee_home in /home/core/mentees/*; do
    if [[ -d "$mentee_home" && ! -s "$mentee_home/$DOMAIN_PREF" ]]; then
      remove_mentee_completely "$mentee_home"
      echo "Removed all traces of deregistered mentee: $(basename "$mentee_home")"
    else
      for domain in web app sysad; do
        if ! grep -q "$domain" "$mentee_home/$DOMAIN_PREF"; then
          mentor_domain_file="/home/core/mentors/${domain}_mentor/task_completed.txt"
          if [[ -f "$mentor_domain_file" ]]; then
            sed -i "/$(basename "$mentee_home")/d" "$mentor_domain_file"
            echo "Removed traces of $domain domain for mentee: $(basename "$mentee_home") from mentor's files."
          fi
        fi
      done
    fi
  done
}

cleanup_deregistered