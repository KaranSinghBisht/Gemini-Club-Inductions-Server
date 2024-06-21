#!/bin/bash

# Function to allocate mentees to mentors using round-robin
allocate_mentees() {
  local mentor_details=("$@")
  local mentor_count=${#mentor_details[@]}
  local mentee_index=0

  # Reading mentee details
  while read -r mentee_name mentee_rollno mentee_domain || [[ -n $mentee_name ]]; do
    # Allocate mentee to mentor
    local mentor_info=${mentor_details[$mentee_index]}
    IFS=' ' read -r mentor_name mentor_domain mentee_capacity allocated_count <<< "$mentor_info"
    
    # Ensure the mentor directory exists
    local mentor_dir="/home/$mentor_name"
    if [ ! -d "$mentor_dir" ]; then
      mkdir -p "$mentor_dir" || { echo "Error: Could not create directory $mentor_dir for $mentor_name"; exit 1; }
    fi

    if [[ "$mentee_domain" == "$mentor_domain" && $allocated_count -lt $mentee_capacity ]]; then
      echo "$mentee_name ($mentee_rollno)" >> "$mentor_dir/allocatedMentees.txt"
      allocated_count=$((allocated_count + 1))
      mentor_details[$mentee_index]="$mentor_name $mentor_domain $mentee_capacity $allocated_count"
    fi

    # Move to the next mentor in round-robin fashion
    mentee_index=$(( (mentee_index + 1) % mentor_count ))
  done < sysad-task1-menteeDetails.txt
}

# Initialize mentor details array
mentor_details=()

# Reading mentor details
while read -r name domain mentee_capacity || [[ -n $name ]]; do
  if [[ "$name" == "Name" && "$domain" == "Domain" && "$mentee_capacity" == "MenteeCapacity" ]]; then
    continue
  fi
  mentor_details+=("$name $domain $mentee_capacity 0")
done < sysad-task1-mentorDetails.txt

# Allocating mentees to mentors using round-robin
allocate_mentees "${mentor_details[@]}"

echo "Mentor allocation completed successfully!"