"""
# Custom Docker Image for Node.js Development

## Overview

This Docker image is designed to provide an environment equipped with NVM (Node Version Manager), Node.js, Yarn, Git, and secure SSH access. It is perfect for developers who need a consistent and isolated development environment for Node.js applications. The image allows for the use of specific Node.js versions and supports passing GitHub credentials at runtime, enabling seamless interaction with Git repositories. It is set up for SSH connections using a password, with the option to use a generated SSH key pair for a more secure, password-less connection. Additionally, the image is compatible with Microsoft Visual Studio Code, allowing developers to connect via Remote Access for an enhanced coding experience.

## Features

- **NVM (Node Version Manager)**: Easily switch between Node.js versions to match project requirements.
- **Node.js and Yarn**: Run Node.js applications and manage dependencies with Yarn.
- **Git**: Clone, push, and pull from repositories with configurable GitHub credentials.
- **Secure SSH Access**: Connect to the container securely using SSH, with support for password and SSH key authentication.
- **VS Code Compatibility**: Use with Microsoft Visual Studio Code's Remote - SSH extension for remote development.

## Getting Started

### Prerequisites

- Docker installed on your machine.
- (Optional) Visual Studio Code and Remote - SSH extension for remote development.

### Running the Container

Use the following `docker run` command to start the container, replacing placeholder values with your actual data:

```bash
docker run -d \\
  -e GITHUB_USERNAME="yourGithubUsername" \\
  -e GITHUB_TOKEN="yourGithubToken" \\
  -e GIT_USER_NAME="yourName" \\
  -e GIT_USER_EMAIL="yourEmail@yourDomain.com" \\
  -e SSH_KEY_EMAIL="yourEmail@yourDomain.com" \\
  -e SSH_KEY_NAME="default" \\
  -e SSH_KEY_PASSPHRASE="yourPassword" \\
  -e SSH_PASSWORD="yourSSHPassword" \\
  -p 22:22 -p 80:80 -p 3000-3010:3000-3010 \\
  -v /home/developer/home:/home \\
  -v /home/developer/root:/root \\
  -v /home/developer/etc_ssh:/etc/ssh \\
  -v /home/developer/usr_local_lib_node_modules:/usr/local/lib/node_modules \\
  your-image-name
```

### Using Docker Compose

Alternatively, you can use `docker-compose` with the provided `docker-compose.yaml` configuration:

```yaml
version: '3.8'
services:
  your-service-name:
    image: your-image-name
    environment:
      GITHUB_USERNAME: "yourGithubUsername"
      GITHUB_TOKEN: "yourGithubToken"
      GIT_USER_NAME: "yourName"
      GIT_USER_EMAIL: "yourEmail@yourDomain.com"
      SSH_KEY_EMAIL: "yourEmail@yourDomain.com"
      SSH_KEY_NAME: "default"
      SSH_KEY_PASSPHRASE: "yourPassword"
      SSH_PASSWORD: "yourSSHPassword"
    ports:
      - "22:22"
      - "80:80"
      - "3000-3010:3000-3010"
    volumes:
      - "/home/developer/home:/home"
      - "/home/developer/root:/root"
      - "/home/developer/etc_ssh:/etc/ssh"
      - "/home/developer/usr_local_lib_node_modules:/usr/local/lib/node_modules"
```

Save this configuration to a `docker-compose.yaml` file and start the service with:

```bash
docker-compose up -d
```

## Connecting via SSH

To connect to the running container via SSH, use the following command:

```bash
ssh root@localhost -p 22
```

Use the `SSH_PASSWORD` you specified when starting the container, or use your SSH key if you've set up key-based authentication.

## Visual Studio Code Remote Development

For remote development with VS Code, ensure you have the Remote - SSH extension installed. Connect to the container by adding an SSH host with the following configuration:

```
Host my-remote-dev
  HostName localhost
  User root
  Port 22
```

Refer to the VS Code documentation on Remote Development for further instructions.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any bugs or feature requests.

## License

"""
