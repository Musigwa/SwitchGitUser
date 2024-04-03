# SwitchGitUser

SwitchGitUser is a shell script designed to simplify the process of switching between different Git user configurations. It's particularly useful for developers who contribute to multiple projects using different Git accounts, allowing for a seamless transition between accounts with ease.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Helpful Resources](#helpful-resources)

## Features

- **Git Account Switching**: Easily switch between predefined Git accounts or enter your own account details.
- **SSH Key Management**: Automatically adds all private SSH keys found in the `~/.ssh/` directory to the SSH agent.
- **GPG Key Selection**: Lists all GPG keys available on the system and allows you to select one for signing commits.
- **Global and Repository-Specific Configurations**: Supports both global and repository-specific Git configurations.

## Prerequisites

This project assumes the user has knowledge with:

- **Git**: Basic understanding of Git commands and configurations.
- **Shell Scripting**: Basic knowledge of shell scripting to understand and modify the script.
- **SSH**: Knowledge of SSH keys and how to add them to the SSH agent.
- **GPG**: Understanding how to generate and manage GPG keys for signing commits.
- **Commit Signature**: Familiarity with signing commits using GPG or SSH keys.

If you're new to any of these topics, here are some helpful resources:

- **Git**: [Git Documentation](https://git-scm.com/doc)
- **Shell Scripting**: [Bash Scripting Tutorial](https://linuxconfig.org/bash-scripting-tutorial-for-beginners)
- **SSH**: [Telling Git about your SSH key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
- **GPG**: [Git: How to Sign Commit with SSH or GPG Key?](https://wenijinew.medium.com/git-how-to-sign-commit-with-ssh-and-gpg-keys-3a4661beddf5)
- **Commit Signature**: [Signing Commits with SSH](https://www.git-tower.com/blog/setting-up-ssh-for-commit-signing/)

## Installation

1. **Clone the Repository**:

```bash
git clone git@github.com:yourusername/SwitchGitUser.git
```

Replace `yourusername` with your GitHub username.

2. **Make the Script Executable**:
   Navigate to the cloned repository and run:

   ```bash
   chmod +x ./switch-git-user.sh
   ```

## Usage

To run the script, execute the following command in your terminal:
Follow the on-screen prompts to select your Git account, add SSH keys to the agent, and select a GPG key for signing commits.

## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-name`.
3. Make your changes.
4. Push your branch: `git push origin feature-name`.
5. Create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the open-source community for the inspiration and support.
- Special thanks to [GitHub](https://github.com) for hosting this project.

## Contact

If you have any questions, feel free to reach out to me by: [email](mailto:pacifique.musigwa@gmail.com).
