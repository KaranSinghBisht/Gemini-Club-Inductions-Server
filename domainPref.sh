#!/bin/bash

# Function to validate domain preference input
validate_domain_prefs() {
  local num_prefs=$#
  if (( num_prefs < 1 || num_prefs > 3 )); then
    echo "Error: Please enter 1, 2, or 3 domain preferences (separated by spaces)."
    return 1
  fi
  for pref in "$@"; do
    if ! [[ "$pref" =~ ^(web|app|sysad)$ ]]; then
      echo "Error: Invalid domain preference. Please enter only web, app, or sysad."
      return 1
    fi
  done
  return 0
}

# Function to update mentee's domain preferences file
update_mentee_prefs() {
  local mentee_file="/home/$USER/domain_pref.txt"
  printf "%s\n" "$@" > "$mentee_file" || { echo "Error: Could not update $mentee_file."; exit 1; }
}

# Function to update core's mentees_domain.txt file
update_core_file() {
  local core_file="/home/DAdmin/mentees_domain.txt"
  local mentee_rollno=$1
  local mentee_name=$2
  shift 2
  local domains=$(printf "%s->" "$@")
  domains=${domains%->}
  printf "%s %s %s\n" "$mentee_rollno" "$mentee_name" "$domains" >> "$core_file" || { echo "Error: Could not update $core_file."; exit 1; }
}

# Input for domain preferences
echo "Enter your domain preferences (web, app, sysad; separated by spaces):"
read -r -a DOMAIN_PREFS

# Validate domain preferences
if ! validate_domain_prefs "${DOMAIN_PREFS[@]}"; then
  exit 1
fi

# Extract mentee roll number and name
MENTEE_ROLLNO=$(echo "$USER" | sed 's/mentee//')
MENTEE_NAME=$(getent passwd "$USER" | cut -d: -f5 | cut -d, -f1) # Assumes full name is in the GECOS field

# Update files with preferences
update_mentee_prefs "${DOMAIN_PREFS[@]}"
update_core_file "$MENTEE_ROLLNO" "$MENTEE_NAME" "${DOMAIN_PREFS[@]}"

# Creating directories for chosen domains
for domain in "${DOMAIN_PREFS[@]}"; do
  DOMAIN_DIR="/home/$USER/$domain"
  if [ ! -d "$DOMAIN_DIR" ]; then
    mkdir "$DOMAIN_DIR" || { echo "Error: Could not create directory $DOMAIN_DIR."; exit 1; }
    echo "Directory created: $DOMAIN_DIR"
  fi
done

echo "Domain preferences updated successfully!"