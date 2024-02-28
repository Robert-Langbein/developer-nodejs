# Base image: Latest Ubuntu
FROM ubuntu:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for NVM, OpenSSH, and Git
RUN apt-get update && \
    apt-get install -y curl git openssh-server nano && \
    apt-get clean && \
    mkdir /var/run/sshd

# Install NVM, Node.js, and Yarn
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 20.11.0
RUN mkdir -p $NVM_DIR

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && nvm alias default $NODE_VERSION

# Make sure Node and NPM are available to all users
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install Yarn globally using NPM
RUN npm install -g yarn

# SSH login fix. Otherwise, user is told root is not allowed
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Modify .bashrc to add nvm, node...
RUN echo 'export NVM_DIR="/usr/local/nvm"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc

# Copy sshd_config
COPY sshd_config /etc/ssh/sshd_config
RUN chmod +x /etc/ssh/sshd_config

# Copy and modify start.sh script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose ports for SSH and your applications
EXPOSE 22 80 3000-3010

# Start SSH server
ENTRYPOINT ["/usr/local/bin/start.sh"]
CMD ["node"]
