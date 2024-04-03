#!/bin/bash

# This is the main function that runs the rest
main() {
    add_ssh_keys_to_agent
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

main
