########################################
# Resources
########################################

# Replacement root password
resource "random_string" "root_password" {
  length      = 30
  special     = true
  number      = true
  upper       = true
  lower       = true
}

# Public SSH key from local file location
resource "digitalocean_ssh_key" "main" {
  name        = "SSH public key"
  public_key  = file(var.public_key)
}

# The new droplet
resource "digitalocean_droplet" "bastion" {
  depends_on  = [
    random_string.root_password,
  ]

  image               = "debian-10-x64"
  name                = var.droplet_name
  region              = local.digital_ocean_region
  size                = "s-1vcpu-1gb"
  ssh_keys            = [digitalocean_ssh_key.main.fingerprint]
  ipv6                = true
  private_networking  = true

  connection {
    type        = "ssh"
    user        = "root"
    agent       = true
    host        = digitalocean_droplet.bastion.ipv4_address
  }

  provisioner "file" {
    source      = "from-zero.sh"
    destination = "/root/from-zero.sh"
  }

  provisioner "remote-exec" {
    inline      = [
      "chmod u+x from-zero.sh",
      # XXX Unfortunately, terraform uses sh for this, which does not support named pipes
      # We could call bash here, but the benefit in term of added security is not significant in that specific context
      "./from-zero.sh '${var.droplet_name}' '${digitalocean_ssh_key.main.public_key}' '${random_string.root_password.result}'",
    ]
  }
}

# IP from already created floating ip (necessary so that docker provider and others can rely on an existing ip in the provider definition)
/*resource "digitalocean_floating_ip_assignment" "bastion" {
  ip_address = var.static_ip
  droplet_id = digitalocean_droplet.bastion.id
}*/

resource "digitalocean_floating_ip" "bastion" {
  region      = "tor1"
}

resource "digitalocean_floating_ip_assignment" "bastion" {
  ip_address  = digitalocean_floating_ip.bastion.ip_address
  droplet_id  = digitalocean_droplet.bastion.id
}

resource "digitalocean_firewall" "bastion" {
  name        = "bastion"

/*  depends_on = [
    docker_container.system-dns-bastion
  ]

  provisioner "local-exec" {
    command = "echo 'supersede domain-name-servers 8.8.8.8, 8.8.4.4;'"
  }*/

  droplet_ids = [digitalocean_droplet.bastion.id]

  # in SSH, from everywhere
  inbound_rule {
    protocol              = "tcp"
    port_range            = "22"
    source_addresses      = ["0.0.0.0/0", "::/0"]
  }

  # in HTTPS (or DNS over TLS masquerading as https), from everywhere
  inbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    source_addresses      = ["0.0.0.0/0", "::/0"]
  }

  # in DNS over TLS
  inbound_rule {
    protocol              = "tcp"
    port_range            = "853"
    source_addresses      = ["0.0.0.0/0", "::/0"]
  }

  # in HTTP
  inbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    source_addresses      = ["0.0.0.0/0", "::/0"]
  }

  # In DNS
  /*
  inbound_rule {
    protocol              = "udp"
    port_range            = "53"
    source_addresses      = ["0.0.0.0/0", "::/0"]
  }

  # in ad-hoc connections
  inbound_rule {
    protocol              = "tcp"
    port_range            = "1000"
    source_addresses      = ["0.0.0.0/0", "::/0"]
  }
  */

  # out dns over tls to everywhere # upstream servers ip
  outbound_rule {
    protocol              = "tcp"
    port_range            = "853"
    destination_addresses = ["0.0.0.0/0", "::/0"] # var.dns_upstream_ips
  }

  # out https and http to anywhere
  # Apparently, debian packages are still on http
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # out dns, to everywhere (actually only helpful until we configure) - but then it would require to wait for the coredns container to be up before setting this, catch 22
  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

/*
  outbound_rule {
    protocol                = "icmp"
    destination_addresses   = ["0.0.0.0/0", "::/0"]
  }*/
}
