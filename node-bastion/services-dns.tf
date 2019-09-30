resource "docker_image" "dns" {
  provider      = docker
  name          = data.docker_registry_image.dns.name
  pull_triggers = [data.docker_registry_image.dns.sha256_digest]

  connection {
    type        = "ssh"
    user        = "docker"
    agent       = true
    host        = var.static_ip # NOTE: ipv4 of the droplet is private, so, depend on the droplet existence, just not on its ip
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/container/config/dns",
      "mkdir -p /home/container/certs/dns",
      "chmod g+rwx /home/container/config/dns",
      "chmod g+rwx /home/container/certs/dns",
    ]
  }
}

resource "docker_container" "dns" {
  provider      = docker
  name          = "dns"
  image         = docker_image.dns.latest

  restart       = "always"

  network_mode  = "bridge"

  env = [
    "STAGING=",
    "OVERWRITE_CONFIG=true",
    "EMAIL=${var.certificate_email}",
    "UPSTREAM_SERVERS=${local.dns_upstream_addresses}",
    "UPSTREAM_NAME=${var.dns_upstream_name}",
    "DOMAIN=${var.certificate_domain}",
  ]

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
    read_only   = false
    type        = "bind"
  }

  mounts {
    target      = "/certs"
    source      = "/home/container/certs/dns"
    read_only   = false
    type        = "bind"
  }
}
