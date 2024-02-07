# Docker Container Setup with SSH Access

This Docker image is designed to provide an environment equipped with NVM (Node Version Manager), Node.js, Yarn, Git, and secure SSH access. It allows for the use of specific Node.js versions and supports passing GitHub credentials at runtime. The image is set up for SSH connections using a password, with the option to use a generated SSH key pair for a more secure, password-less connection. It is also compatible with Microsoft Visual Studio Code to connect via Remote Access.

## Features

- **Ubuntu:** Uses the latest version as the base image.
- **NVM, Node.js, and Yarn:** Comes pre-installed for easy management of Node.js versions and packages.
- **OpenSSH:** Configured for secure connections.
- **Git:** Can be configured with your GitHub credentials at runtime.
- **Visual Studio Code Remote Access:** Compatible with Microsoft Visual Studio Code to connect via Remote Access.

## Environment Variables

You can customize the container with the following environment variables:

- `GITHUB_USERNAME`: Your GitHub username (optional).
- `GITHUB_TOKEN`: Your GitHub token for CLI operations (optional).
- `GIT_USER_NAME`: Your name for Git configuration.
- `GIT_USER_EMAIL`: Your email for Git configuration.
- `SSH_PASSWORD`: The password for SSH access. If not set, a default password will be used.
- `SSH_KEY_EMAIL`: The email address for SSH key generation.
- `SSH_KEY_NAME`: The name of the SSH key file.
- `SSH_KEY_PASSPHRASE`: The passphrase which will be used to generate the SSH keys.
- `NODE_VERSION`: The Node version you want to be installed.

## Connecting to the Container

### Primary Method: Using SSH with Password to Access SSH Keys

The easiest way to access the container and retrieve the SSH keys is via SSH using the root password. This method is straightforward and doesn't require direct access to the Docker host.

1. **Connect to the Container via SSH:**
   - Make sure the container is running and obtain its IP address.
   - Use the following command to connect:
     ```
     ssh root@[container_ip]
     ```
     Replace `[container_ip]` with the actual IP address of your container.
   - Enter the `SSH_PASSWORD` when prompted. If you haven't specified one, use the default password provided by the container setup.

2. **Retrieve the Generated SSH Key:**
   - Once logged in, navigate to `/root/.ssh`.
   - Use `cat id_rsa` to display your private SSH key and copy it to your local machine for future SSH connections.
   - Similarly, `cat id_rsa.pub` can be used to view the public key.

### Secondary Method: Using Generated SSH Key for Password-less Access (Optional)

For enhanced security, the container automatically generates an SSH key pair if it doesn't find an existing pair in `/root/.ssh`. This allows for a secure, password-less connection.

- To use this method, first follow the primary method to access the container and retrieve the private key (`id_rsa`).
- On your local machine, save this key to a secure location and set appropriate permissions:
  ```
  chmod 600 /path/to/your/private/key
  ```
- Connect to the container using the SSH key:
  ```
  ssh -i /path/to/your/private/key root@[container_ip]
  ```
## Security Note

While connecting using SSH and a password is straightforward, utilizing SSH keys provides a more secure connection method. Ensure your private keys are stored securely and are not shared with unauthorized users.
