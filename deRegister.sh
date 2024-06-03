#!/bin/bash

# Define file paths
DOMAIN_PREF="domain_pref.txt"

# Function to get mentee home directory
get_mentee_home() {
  echo "$HOME"
}

# Function to deregister mentee
deregister_mentee() {
  local domain=$1
  local mentee_home=$(get_mentee_home)

  # Checking if domain preference file exists
  if [[ ! -f "$mentee_home/$DOMAIN_PREF" ]]; then
    echo "Error: Domain preference file not found for mentee." >&2
    exit 1
  fi

  # Removing domain from domain preference file using awk
  awk -v d="$domain" '$0 != d' "$mentee_home/$DOMAIN_PREF" > "$mentee_home/${DOMAIN_PREF}.tmp" && mv "$mentee_home/${DOMAIN_PREF}.tmp" "$mentee_home/$DOMAIN_PREF" || { echo "Error: Failed to remove domain from preference file." >&2; exit 1; }

  # Checking if domain directory exists before deletion
  if [[ -d "$mentee_home/$domain" ]]; then
    rm -rf "$mentee_home/$domain" || { echo "Error: Failed to remove domain directory." >&2; exit 1; }
  fi

  echo "Mentee deregistered from $domain successfully."
}

# Actual main function for deregistration
deRegister() {
  local domain=$1

  # Checking if domain argument is provided
  if [[ -z $domain ]]; then
    echo "Error: Domain not provided." >&2
    exit 1
  fi

  deregister_mentee "$domain"
}

# Call deRegister function with provided domain argument
deRegister "$1"