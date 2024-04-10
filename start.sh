#!/bin/bash

# Load NVM and set PATH
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set the SSH password based on the environment variable
echo "root:${SSH_PASSWORD:-default}" | chpasswd

# Generate SSH key if not already present
SSH_KEY_PATH="/root/.ssh/${SSH_KEY_NAME:-default}"
if [ ! -f "$SSH_KEY_PATH" ] && [ ! -f "$SSH_KEY_PATH.pub" ]; then
    # Ensure the .ssh directory exists
    mkdir -p /root/.ssh
    # Check if SSH_KEY_PASSPHRASE is set and not empty
    if [ -n "${SSH_KEY_PASSPHRASE}" ]; then
        passphrase_option="-N ${SSH_KEY_PASSPHRASE}"
    else
        passphrase_option="-N ''"
    fi
    # Generating SSH key with the provided email and optional passphrase
    ssh-keygen -t rsa -b 4096 -C "${SSH_KEY_EMAIL:-youremail@yourdomain.com}" $passphrase_option -f "$SSH_KEY_PATH"
    echo "SSH key generated at $SSH_KEY_PATH"
    
    # Copy the public key content to authorized_keys and set proper permissions
    cat "${SSH_KEY_PATH}.pub" >> /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    echo "Public SSH key added to /root/.ssh/authorized_keys"
else
    echo "SSH keys already exist."
fi

# Remove old keys that were added by this script
sed -i '/"SSH_PUBLIC_KEY_[0-9]\+"/d' /root/.ssh/authorized_keys

# Add custom public keys based on given SSH_PUBLIC_KEY_n environment variable(s)
for ((i=0; i<=99; i++)); do
    varname="SSH_PUBLIC_KEY_${i}"
    key="${!varname}"
    if [[ -n "$key" ]]; then
        echo "Implementing SSH key ${varname}..."
        # Add the key and mark it with the variable name for identification
        echo "$key \"${varname}\"" >> /root/.ssh/authorized_keys
    fi
done

# Configure Git with the provided username and email from environment variables
git config --global user.name "${GIT_USER_NAME:-Your Name}"
git config --global user.email "${GIT_USER_EMAIL:-youremail@yourdomain.com}"

# Set Git to use the token as password for the GitHub username permanently
git config --global credential.helper store
echo "https://${GIT_USER_NAME}:${GIT_USER_TOKEN}@github.com" > /root/.git-credentials

# Adding NVM to .bashrc for command-line usage
echo 'export NVM_DIR="/usr/local/nvm"' >> /root/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc

# Starting the SSH server in the foreground
/usr/sbin/sshd -D
