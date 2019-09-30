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

  # XXX there seem to be a bug in the file provisioner, using HEREDOC content: if the destination is foo/bar, the actual content is put in a file named foo
  # Creating the directory beforehand does workaround that
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/container/config/dns",
      "mkdir -p /home/container/data/dns",
      "chmod g+rwx /home/container/config/dns",
      "chmod g+rwx /home/container/data/dns",
    ]
  }

  # Copy over the configuration
  provisioner "file" {

    content     = <<EOF
# Classic DNS on 53, forwarding to a DoT upstream
.:{$DNS_PORT} {
  forward . ${local.dns_upstream_addresses} {
    tls_servername ${var.dns_upstream_name}
    health_check 5s
  }

  cache 86400

  log
  errors
}

# Hot reload configuration
. {
    reload
    erratic
}

# DoT with letsencrypt cert, forwarding as well to a DoT server
tls://.:{$TLS_PORT} {
	tls /data/certificates/${var.dns_name}.crt /data/certificates/${var.dns_name}.key certificates/${var.dns_name}.issuer.crt

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

resource "docker_container" "dns" {
  provider      = docker
  name          = "dns"
  image         = docker_image.dns.latest

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
