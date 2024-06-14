#!/bin/bash

# Define the aliases to add
declare -A ALIASES
ALIASES=(
    ["userGen"]="alias userGen='./userGen.sh'"
    ["domainPref"]="alias domainPref='./domainPref.sh'"
    ["mentorAllocation"]="alias mentorAllocation='./mentorAllocation.sh'"
    ["submitTask"]="alias submitTask='./submitTask.sh'"
    ["displayStatus"]="alias displayStatus='./displayStatus.sh'"
    ["deRegister"]="alias deRegister='./deRegister.sh'"
    ["setQuiz"]="alias setQuiz='./setQuiz.sh'"
)

# Path to .bashrc file
BASHRC_FILE="$HOME/.bashrc"

# Function to add alias if it doesn't exist
add_alias() {
    local ALIAS_NAME=$1
    local ALIAS_COMMAND=$2

    if grep -q "$ALIAS_COMMAND" "$BASHRC_FILE"; then
        echo "Alias '$ALIAS_NAME' already exists in $BASHRC_FILE"
    else
        echo "$ALIAS_COMMAND" >> "$BASHRC_FILE"
        echo "Alias '$ALIAS_NAME' added to $BASHRC_FILE"
    fi
}

# Iterate over the aliases and add them if necessary
for ALIAS_NAME in "${!ALIASES[@]}"; do
    add_alias "$ALIAS_NAME" "${ALIASES[$ALIAS_NAME]}"
done

# Source the .bashrc file to apply changes immediately
source "$BASHRC_FILE"
echo ".bashrc sourced to apply changes"