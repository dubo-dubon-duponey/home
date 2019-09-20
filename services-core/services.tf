resource "docker_image" "system-dns-bastion" {
  provider      = docker
  name          = data.docker_registry_image.system-dns.name
  pull_triggers = [data.docker_registry_image.system-dns.sha256_digest]

  connection {
    type        = "ssh"
    user        = "docker"
    agent       = true
    host        = var.static_ip # NOTE: ipv4 of the droplet is private, so, depend on the droplet existence, just not on its ip
  }

  # XXX there seem to be a bug in the file provisioner, using HEREDOC content: if the destination is foo/bar, the actual content is put in a file named foo
  # Creating the directory beforehand does workaround that
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/container/config/dns",
      "mkdir -p /home/container/data/dns",
      "chown container:docker /home/container/config/dns",
      "mkdir container:docker /home/container/data/dns",
    ]
  }

  # Copy over the configuration
  provisioner "file" {

    content     = <<EOF
127.0.0.1:{$DNS_PORT} {
    forward . ${local.dns_upstream_addresses} {
       tls_servername ${var.dns_upstream_name}
       health_check 5s
    }

    cache 86400

    log
    errors
}
    EOF
    # XXX see above
    destination = "/home/container/config/dns/config.conf"
  }
}

# Copies the configs.d folder to /etc/configs.d
#  provisioner "file" {
#    source      = "config"
#    destination = "/etc"
#  }

resource "docker_container" "system-dns-bastion" {
  provider      = docker
  name          = "dns"
  image         = docker_image.system-dns-bastion.latest

  connection {
    type        = "ssh"
    user        = "docker"
    agent       = true
    host        = var.static_ip # NOTE: ipv4 of the droplet is private, so, depend on the droplet existence, just not on its ip
  }

  restart       = "always"

  network_mode  = "bridge"

  capabilities {
    drop = ["ALL"]
  }

  # Regular DNS service
  ports {
    internal    = 1053
    external    = 53
    protocol    = "udp"
  }

  # DNS over TLS #, masquerading as HTTPS
  ports {
    internal    = 1853
    # external    = 443
    external    = 853
  }

  # Lego port publication for TLS challenge
  ports {
    internal    = 1443
    external    = 443
  }

  mounts {
    target      = "/config"
    source      = "/home/container/config/dns"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/data"
    source      = "/home/container/data/dns"
    read_only   = false
    type        = "bind"
  }
}
