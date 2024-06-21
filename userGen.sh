#!/bin/bash

# Core admin details
CORE_USERNAME="DAdmin"
CORE_PASSWORD="Delta2024"

# Core user
sudo useradd -m -s /bin/bash "$CORE_USERNAME"
echo "$CORE_USERNAME:$CORE_PASSWORD" | sudo chpasswd

# Creating directories for mentors and mentees
sudo mkdir -p "/home/$CORE_USERNAME/mentors" "/home/$CORE_USERNAME/mentees"

# Creating groups for mentors and mentees
sudo groupadd mentorsgroup
sudo groupadd menteesgroup

# Function to check if a user exists
user_exists() {
    id "$1" &>/dev/null
}

# Reading mentor details from sysad-task1-mentorDetails.txt
while read -r NAME DOMAIN MENTEE_CAPACITY || [[ -n $NAME ]]; do
    # Skip the header or empty lines
    [[ "$NAME" == "Name" && "$DOMAIN" == "Domain" && "$MENTEE_CAPACITY" == "MenteeCapacity" ]] && continue
    [[ -z "$NAME" || -z "$DOMAIN" || -z "$MENTEE_CAPACITY" ]] && continue

    # Extracting name and domain
    MENTOR_USERNAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')_mentor
    case $DOMAIN in
        web) DOMAIN_DIR="Webdev" ;;
        app) DOMAIN_DIR="Appdev" ;;
        sysad) DOMAIN_DIR="Sysad" ;;
        *) echo "Unknown domain: $DOMAIN"; exit 1 ;;
    esac

    # Creating mentor account and directories if not exists
    if ! user_exists "$MENTOR_USERNAME"; then
        sudo useradd -m -s /bin/bash "$MENTOR_USERNAME"
        sudo usermod -d "/home/$CORE_USERNAME/mentors/$DOMAIN_DIR/$MENTOR_USERNAME" "$MENTOR_USERNAME"
        sudo usermod -aG mentorsgroup "$MENTOR_USERNAME"
    fi

    # Creating mentor directories and files
    sudo mkdir -p "/home/$CORE_USERNAME/mentors/$DOMAIN_DIR/$MENTOR_USERNAME/submittedTasks/task"{1,2,3}
    sudo touch "/home/$CORE_USERNAME/mentors/$DOMAIN_DIR/$MENTOR_USERNAME/allocatedMentees.txt"
    sudo chown -R "$MENTOR_USERNAME:mentorsgroup" "/home/$CORE_USERNAME/mentors/$DOMAIN_DIR/$MENTOR_USERNAME"
    sudo chmod -R u+rwx,g+rx,o-rwx "/home/$CORE_USERNAME/mentors/$DOMAIN_DIR/$MENTOR_USERNAME"
done < sysad-task1-mentorDetails.txt

# Reading mentee details from sysad-task1-menteeDetails.txt
while read -r NAME ROLLNO || [[ -n $NAME ]]; do
    # Skip the header or empty lines
    [[ "$NAME" == "Name" && "$ROLLNO" == "RollNo" ]] && continue
    [[ -z "$NAME" || -z "$ROLLNO" ]] && continue

    # Creating mentee account and directories if not exists
    MENTEE_USERNAME="mentee$ROLLNO"
    if ! user_exists "$MENTEE_USERNAME"; then
        sudo useradd -m -s /bin/bash "$MENTEE_USERNAME"
        sudo usermod -d "/home/$CORE_USERNAME/mentees/$MENTEE_USERNAME" "$MENTEE_USERNAME"
        sudo usermod -aG menteesgroup "$MENTEE_USERNAME"
    fi

    # Creating mentee directories and files
    sudo mkdir -p "/home/$CORE_USERNAME/mentees/$MENTEE_USERNAME"
    sudo touch "/home/$CORE_USERNAME/mentees/$MENTEE_USERNAME/domain_pref.txt" 
    sudo touch "/home/$CORE_USERNAME/mentees/$MENTEE_USERNAME/task_completed.txt" 
    sudo touch "/home/$CORE_USERNAME/mentees/$MENTEE_USERNAME/task_submitted.txt"
    sudo chown -R "$MENTEE_USERNAME:menteesgroup" "/home/$CORE_USERNAME/mentees/$MENTEE_USERNAME"
    sudo chmod -R u+rwx,g-rwx,o-rwx "/home/$CORE_USERNAME/mentees/$MENTEE_USERNAME"
done < sysad-task1-menteeDetails.txt

# Setting permissions for Core Admin
sudo chmod -R u+rwx,go-rwx "/home/$CORE_USERNAME"

# Creating mentees_domain.txt
sudo touch "/home/$CORE_USERNAME/mentees_domain.txt"
sudo chown :menteesgroup "/home/$CORE_USERNAME/mentees_domain.txt"
sudo chmod g+w,go-rx "/home/$CORE_USERNAME/mentees_domain.txt"

# Allowing Core to access everyone's home directory
sudo setfacl -R -m u:$CORE_USERNAME:rwx /home/$CORE_USERNAME/mentees/*
sudo setfacl -R -m u:$CORE_USERNAME:rwx /home/$CORE_USERNAME/mentors/*

echo "Users and directories created successfully!"