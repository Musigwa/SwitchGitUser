#!/bin/bash

# This is the main function that runs the rest
main() {
    add_ssh_keys_to_agent
    select_gpg_key
}

add_ssh_keys_to_agent() {
    # Start the SSH agent
    eval "$(ssh-agent -s)"

    # Check if SSH_AUTH_SOCK is set
    if [ -z "$SSH_AUTH_SOCK" ]; then
        # Start the ssh-agent in the background
        eval `ssh-agent -s`
    fi

    # List all private SSH keys, excluding public keys
    ssh_keys=$(ls ~/.ssh/id_* 2>/dev/null | grep -v '\.pub$')

    # Check if no keys were found
    if [ -z "$ssh_keys" ]; then
        echo "No private SSH keys found in ~/.ssh/."
        exit 1
    fi

    # Add each SSH key to the ssh-agent
    for key in $ssh_keys; do
        # Check if the key is already added to the agent
        ssh-add -l | grep -q "$key" || ssh-add --apple-use-keychain "$key"
    done
}

# Function to list GPG keys and prompt for selection
select_gpg_key() {
    echo "Select a GPG key to use for signing commits:"
    echo "-------------------------------------------"
    # List GPG keys
    gpg --list-secret-keys --keyid-format LONG | grep -E 'uid' | awk 'BEGIN{FS="<"}{gsub(/>/,"",$2); print NR") " $2}'
    echo "-------------------------------------------"
    # Prompt for selection
    read -p "Enter the number of the GPG key: " selection
    # Get the selected GPG key ID
    selected_gpg_key=$(gpg --list-secret-keys --keyid-format LONG | grep -E 'uid' | awk "NR==$selection{print}")
    # Extract the GPG key ID from the selected line
    selected_gpg_key=$(echo $selected_gpg_key | awk 'BEGIN{FS="<"}{gsub(/>/,"",$2); print $2}')
    echo "Switching to GPG key: $selected_gpg_key"
    # Set the selected GPG key
    git config --global user.signingkey $selected_gpg_key
    git config --global commit.gpgsign true
    git config --global tag.gpgSign true
    # Optionally set an signed tag alias (stag) ex usage: > git stag ...
    git config --global alias.stag 'tag -s'
}

main
