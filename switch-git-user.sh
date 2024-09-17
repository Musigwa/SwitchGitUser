#!/bin/bash

# This is the main function that runs the rest
main() {
    select_git_account
    add_ssh_keys_to_agent
    select_gpg_key
}

select_git_account() {
    # Enable nocasematch
    shopt -s nocasematch

    # Define a list of hardcoded names and emails
    declare -a accounts=("pacifique.musigwa@gmail.com" "p.musigwa@irembo.com")

    # Default account's name and email 
    declare name="MUSIGWA Pacifique"
    declare email="${accounts[0]}"

    indices=""
    for ((i = 0; i < ${#accounts[@]}; i++)); do
        indices+="$(($i + 1)), "
        echo "$((${i} + 1)) ${name} - ${accounts[$i]}"
    done

    echo "$((${#accounts[@]} + 1))) Enter your own name and email"
    
    # Let's get the user's input from the command line
    # while true; do
    read -p "Enter the number of the account, or $((${#accounts[@]} + 1)) to enter your own. q(quit): " selection
    case $selection in
        1)
            email=$(echo "${accounts[0]}")
            break
            ;;
        2)
            email=$(echo "${accounts[1]}")
            break
            ;;
        $((${#accounts[@]} + 1)))
            read -p "Enter the account full name (space separated): " name
            read -p "Enter the account email: " email
            ;;
        q|quit)
            exit 0
            ;;
        *)
            echo "Invalid input. Please choose one of these: $indices"or" $((${#accounts[@]} + 1))."
            ;;
    esac
    # done

    while true; do
        read -p "Set as (--global)? Otherwise, make sure you're in a git repo. (y/N): " global        
        case $global in
            y|yes)
                global=--global
                break
                ;;
            n|no)
                global=
                break
                ;;
            q|quit)
                exit 0
                ;;
            *)
                echo "Invalid input. Please enter y/yes, n/no. (Case insensitive)"
                ;;
        esac
    done

    # Set the user configurations as necessary
    echo "Setting user configurations as: $name - $email"
    git config $global user.name "${name}"
    git config $global user.email "${email}"

    # Disable nocasematch if you don't want it to affect other parts of your script
    shopt -u nocasematch
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
