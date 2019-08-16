resource "null_resource" "machine" {
  depends_on = [
    random_string.new_pwd,
  ]

  connection {
    type      = "ssh"
    user      = var.user
    password  = var.password
    host      = var.ip
    port      = local.factory_port
    agent     = false
  }

  # Package refresh base
  provisioner "remote-exec" {
    inline = [
      "echo '>>>>>>>> Base <<<<<<<<'",
      "sudo apt-get update > /dev/null",
      "sudo apt-get dist-upgrade -y > /dev/null",
      "sudo apt-get install -y lsof > /dev/null",
      "printf '${var.hostname}\\n' | sudo tee /etc/hostname",
      "[ -d /home/${var.user}/.ssh ] || mkdir /home/${var.user}/.ssh",
      "sudo grep -q '${var.wifi_ssid}' /etc/wpa_supplicant/wpa_supplicant.conf || printf 'country=US\\nnetwork={\\n       ssid=\"${var.wifi_ssid}\"\\n       psk=${var.wifi_psk}\\n}\\n' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf",
      "sudo wpa_cli -i wlan0 reconfigure",
    ]
  }

  # Configure unattended upgrades
  provisioner "remote-exec" {
    inline = [
      "echo '>>>>>>>> Unattended <<<<<<<<'",
      # NOTE: check that it works with sudo unattended-upgrade -d -v --dry-run
      "sudo apt-get install -y --no-install-recommends unattended-upgrades",
      "printf 'APT::Periodic::Update-Package-Lists \"1\";\\n'           | sudo tee    /etc/apt/apt.conf.d/51-dmp-unattended-upgrades",
      "printf 'APT::Periodic::Download-Upgradeable-Packages \"1\";\\n'  | sudo tee -a /etc/apt/apt.conf.d/51-dmp-unattended-upgrades",
      "printf 'APT::Periodic::Unattended-Upgrade \"1\";\\n'             | sudo tee -a /etc/apt/apt.conf.d/51-dmp-unattended-upgrades",
      "printf 'APT::Periodic::AutocleanInterval \"7\";\\n'              | sudo tee -a /etc/apt/apt.conf.d/51-dmp-unattended-upgrades",
      # XXX this is a problem with system using encrypted partitions requiring manual input of password
      "printf 'Unattended-Upgrade::Automatic-Reboot \"false\";\\n'       | sudo tee -a /etc/apt/apt.conf.d/51-dmp-unattended-upgrades",
      "printf 'Unattended-Upgrade::Origins-Pattern {\\n'                | sudo tee -a /etc/apt/apt.conf.d/51-dmp-unattended-upgrades",
      "printf '        \"origin=*\";\\n'                                | sudo tee -a /etc/apt/apt.conf.d/51-dmp-unattended-upgrades",
      "printf '};\\n'                                                   | sudo tee -a /etc/apt/apt.conf.d/51-dmp-unattended-upgrades",
    ]
  }

  # Install docker
  provisioner "remote-exec" {
    inline = [
      "echo '>>>>>>>> Docker <<<<<<<<'",
      "sudo apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl software-properties-common > /dev/null",
      "curl -fsSL \"https://download.docker.com/linux/$(lsb_release --id -s | tr '[:upper:]' '[:lower:]')/gpg\" | sudo apt-key add -",
      "sudo apt-key fingerprint 0EBFCD88",
      "printf \"deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(lsb_release --id -s | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable\\n\" | sudo tee /etc/apt/sources.list.d/docker.list",
      "sudo apt-get update > /dev/null",
      "sudo apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io > /dev/null",
      "sudo usermod -aG docker ${var.user}",
    ]
  }

  provisioner "file" {
    source      = var.ssh_public_key
    destination = "/home/${var.user}/.ssh/authorized_keys"
  }

  # Tweak network and install ufw
  provisioner "remote-exec" {
    inline = [
      # Mostly useful for hungry apps like transmission
      "grep -q 'net.core.rmem_max = 16777216' /etc/sysctl.conf || printf 'net.core.rmem_max = 16777216\\n' | sudo tee -a /etc/sysctl.conf",
      "grep -q 'net.core.wmem_max = 16777216' /etc/sysctl.conf || printf 'net.core.wmem_max = 16777216\\n' | sudo tee -a /etc/sysctl.conf",
      # Useful with docker + roon
      "grep -q 'fs.inotify.max_user_watches = 1048576' /etc/sysctl.conf || printf 'fs.inotify.max_user_watches = 1048576\\n' | sudo tee -a /etc/sysctl.conf",


      #"sudo apt-get install -y --no-install-recommends ufw > /dev/null",
      #"sudo ufw disable",

      #"sudo ufw default deny incoming on ${var.iface}",
      # Deny outgoing
      #"sudo ufw default deny outgoing on ${var.iface}",

      # Allow incoming on ssh - because
      #"sudo ufw allow in on ${var.iface} to any port ${local.factory_port} proto tcp", # ssh
      # Allow incoming on https - because
      #"sudo ufw allow in on ${var.iface} to any port 443 proto tcp", # nginx

      # Allow ssh, DNS and https connections to the outside world
      # "sudo ufw allow out on ${local.nuc_fact_iface} to any port ${local.nuc_fact_port} proto tcp",
      #"sudo ufw allow out on ${var.iface} to any port 53 proto udp",
      #"sudo ufw allow out on ${var.iface} to any port 443 proto tcp",

      # XXX enable
      # "sudo ufw --force enable",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "echo '>>>>>>>> SSH <<<<<<<<'",
      "sudo sed -i.bak 's/^#?PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config",
      # XXX reenable
      "sudo sed -i.bak 's/^#?PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config",
      "grep -q 'AllowUsers ${var.user}' /etc/ssh/sshd_config || printf 'AllowUsers ${var.user}\\n' | sudo tee -a /etc/ssh/sshd_config",
      "chmod -R og-rwx /home/${var.user}/.ssh",
      # XXX reenable
      "printf \"${var.user}:${random_string.new_pwd.result}\" | sudo chpasswd",
      "printf \"root:${random_string.new_pwd.result}\" | sudo chpasswd",
      # XXX Move to ed25519
      # [root@arch ssh]# mv ssh_host_* ./backup/
      # [root@arch ssh]# ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
      # HostKey /etc/ssh/ssh_host_ed25519_key
    ]
  }

  # Disable wifi, bluetooth, and onboard sound chip, configure hifiberry dac top
  provisioner "remote-exec" {
    inline = [
      "echo '>>>>>>>> System <<<<<<<<'",
      "[ ! \"${var.dac_disable_wifi}\" ]   || grep -q 'dtoverlay=pi3-disable-wifi' /boot/config.txt  || printf 'dtoverlay=pi3-disable-wifi\\n'   | sudo tee -a /boot/config.txt",
      "[ ! \"${var.dac_disable_blue}\" ]   || grep -q 'dtoverlay=pi3-disable-bt' /boot/config.txt    || printf 'dtoverlay=pi3-disable-bt\\n'     | sudo tee -a /boot/config.txt",
      "[ ! \"${var.dac_disable_audio}\" ]  || grep -q 'dtoverlay=hifiberry-dacplus' /boot/config.txt || printf 'dtoverlay=hifiberry-dacplus\\n'  | sudo tee -a /boot/config.txt",
      "[ ! \"${var.dac_disable_audio}\" ]  || sudo sed -i.bak 's/^dtparam=audio=on/# dtparam=audio=on/g' /boot/config.txt",

      # XXX move this into containers that need it, if they need it
      # "printf 'pcm.!default {\\n    type hw card 0\\n}\\n\\n'       | sudo tee /etc/asound.conf",
      # "printf 'ctl.!default {\\n    type hw card 0\\n}\\n'          | sudo tee -a /etc/asound.conf",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 1",
      # XXX "sudo systemctl restart ssh",
      # XXX re-enable
      # "reboot now",
    ]
  }
}
