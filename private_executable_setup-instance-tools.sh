#!/bin/bash

# install ivim
bash <(curl -L https://raw.githubusercontent.com/kepbod/ivim/master/setup.sh) -i

# install fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf;
~/.fzf/install

# install required packages
sudo apt update && sudo apt upgrade --assume-yes
sudo --preserve-env apt install --assume-yes unzip zip bash-completion python3-pip exa

# install aws cli
AWS_CLI_VERSION=2.11.1
AWS_CLI_URL=https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
curl ${AWS_CLI_URL} --output /tmp/awscli.zip
unzip /tmp/awscli.zip -d /tmp/awscli/
/tmp/awscli/aws/install \
    --install-dir $HOME/tools/aws/cli \
    --bin-dir $HOME/.local/bin
rm -rf /tmp/awscli.zip /tmp/awscli/
printf `complete -C "$HOME/.local/bin/aws_completer" aws` >> $HOME/.bash_aliases

# install aws cli ssm plugin
AWS_SSM_URL=https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb
curl ${AWS_SSM_URL} --output /tmp/session-manager-plugin.deb
sudo dpkg -i /tmp/session-manager-plugin.deb
rm -fr /tmp/session-manager-plugin.deb

# install aws2-wrap
AWS2_WRAP_VERSION=1.3.1
sudo --preserve-env pip install aws2-wrap=={AWS2_WRAP_VERSION}
sudo --preserve-env apt clean

# extend the exported environment variable PATH
printf "export PATH=\"\${PATH}:\${HOME}/bin\"\n" >> ~/.bashrc

# add shortcut aliases to .bashrc for files and directory listing
sed -i "s/alias ll='ls -alF'/alias ll='exa -lF'/g" ~/.bashrc
LINE=$(grep -nr "alias l='ls -CF'" ~/.bashrc | cut -d':' -f1)
sed -i "${LINE}ialias lll='exa -alF'" ~/.bashrc

# install docker
curl -fsSL https://get.docker.com -o ~/get-docker.sh
sudo sh ~/get-docker.sh
sudo usermod -a -G docker ${USER}

