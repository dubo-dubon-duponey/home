#!/usr/bin/env bash

hostname="$1"
pubkey="$2"
password_root="$3"

init::title(){
  local title="$1"

  >&2 printf ">>>>>>>> $title <<<<<<<<\n"
}

init::update(){
  sudo apt-get update > /dev/null
  sudo apt-get dist-upgrade -y > /dev/null
}

init::hostname(){
  local name="$1"

  printf "$name\n" | sudo tee /etc/hostname
}

init::limits(){
  # Mostly useful for hungry apps like transmission
  grep -q 'net.core.rmem_max = 16777216'          /etc/sysctl.conf || printf "net.core.rmem_max = 16777216\n" | sudo tee -a /etc/sysctl.conf
  grep -q 'net.core.wmem_max = 16777216'          /etc/sysctl.conf || printf "net.core.wmem_max = 16777216\n" | sudo tee -a /etc/sysctl.conf
  # Useful with docker + roon for eg
  grep -q 'fs.inotify.max_user_watches = 1048576' /etc/sysctl.conf || printf "fs.inotify.max_user_watches = 1048576\n" | sudo tee -a /etc/sysctl.conf
  sysctl -p
}


init::unattended(){
  sudo apt-get install -y --no-install-recommends unattended-upgrades > /dev/null
  printf 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Origins-Pattern {
  "origin=*";
};
' | sudo tee /etc/apt/apt.conf.d/51-dmp-unattended-upgrades
}

init::docker(){
  local pub="$1"

  sudo apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl software-properties-common gnupg > /dev/null
  curl -fsSL "https://download.docker.com/linux/$(lsb_release --id -s | tr '[:upper:]' '[:lower:]')/gpg" | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  printf "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(lsb_release --id -s | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable\n" | sudo tee /etc/apt/sources.list.d/docker.list

  sudo apt-get update > /dev/null
  sudo apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io > /dev/null

  # User account to start and stop containers
  sudo adduser \
    --gecos "docker management account" \
    --ingroup docker \
    --uid 500 \
    --disabled-password \
    docker

  # Setup docker administrative account and ssh access
  [ -d /home/docker/.ssh ] || sudo mkdir -p /home/docker/.ssh
  sudo printf "%s" "$pub" > /home/docker/.ssh/authorized_keys
  sudo chown -R docker:docker /home/docker
  sudo chmod -R go-rwx /home/docker/.ssh

  # Setup in-container management account
  sudo addgroup --system --gid 1000 container
  sudo adduser --system --disabled-login --no-create-home --home /nonexistent --shell /bin/false \
    --gecos "in container user" \
    --ingroup container \
    --uid 1000 \
    --disabled-password \
    container

  # Set data path
  sudo mkdir -p /home/container/config
  sudo mkdir -p /home/container/data
  sudo chown -R container:docker /home/container
  sudo chmod -R g+rwxs /home/container
}

init::ssh(){
  local root="$1"

  sudo sed -i'' 's/^#? ?PermitRootLogin yes/PermitRootLogin no/g'               /etc/ssh/sshd_config
  sudo sed -i'' 's/^#? ?PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
  grep -q 'AllowUsers docker' /etc/ssh/sshd_config || printf "AllowUsers docker\n" | sudo tee -a /etc/ssh/sshd_config
  sudo systemctl restart ssh
  printf "root:%s" "$root"            | sudo chpasswd
}

init::title Base
init::update
init::hostname "$hostname"
init::limits

init::title Unattended
# NOTE: check that it works with sudo unattended-upgrade -d -v --dry-run
init::unattended

init::title Docker
init::docker "$pubkey"

init::title SSH
init::ssh "$password_root"
