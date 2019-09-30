resource "docker_image" "dns" {
  provider      = docker
  name          = data.docker_registry_image.dns.name
  pull_triggers = [data.docker_registry_image.dns.sha256_digest]

  connection {
    type        = "ssh"
    user        = "dmp"
    agent       = true
    host        = "localhost"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.docker_config}/config/dns",
      "mkdir -p ${var.docker_config}/certs/dns",
      "chmod g+rwx ${var.docker_config}/config/dns",
      "chmod g+rwx ${var.docker_config}/certs/dns",
    ]
  }

  # Copy over the configuration
  provisioner "file" {

    content     = <<EOF
.:{$DNS_PORT} {
  forward . {$UPSTREAM_SERVERS} {
    tls_servername {$UPSTREAM_NAME}
    health_check 5s
  }

  cache 86400

  log
  errors

  reload
  erratic
}
    EOF
    destination = "${var.docker_config}/config/dns/config.conf"
  }
}

resource "docker_container" "dns" {
  provider      = docker
  name          = "dns"
  image         = docker_image.dns.latest

  connection {
    type        = "ssh"
    user        = "dmp"
    agent       = true
    host        = "localhost"
  }

  restart       = "always"

  network_mode  = "bridge"

  env = [
    "STAGING=true",
    "DOMAIN=",
    "OVERWRITE_CONFIG=",
    "UPSTREAM_SERVERS=${local.dns_upstream_addresses}",
    "UPSTREAM_NAME=${var.dns_upstream_name}",
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

  mounts {
    target      = "/config"
    source      = "${var.docker_config}/config/dns"
    read_only   = false
    type        = "bind"
  }
}
