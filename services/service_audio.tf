# Images
resource "docker_image" "airport-nucomedon" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.audio-airport.name
  pull_triggers = [data.docker_registry_image.audio-airport.sha256_digest]
}

resource "docker_image" "airport-croquette" {
  provider      = docker.dacodac
  name          = data.docker_registry_image.audio-airport.name
  pull_triggers = [data.docker_registry_image.audio-airport.sha256_digest]
}

resource "docker_image" "airport-nightingale" {
  provider      = docker.nightingale
  name          = data.docker_registry_image.audio-airport.name
  pull_triggers = [data.docker_registry_image.audio-airport.sha256_digest]
}

resource "docker_image" "roon" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.audio-roon.name
  pull_triggers = [data.docker_registry_image.audio-roon.sha256_digest]
}

resource "docker_image" "raat-dacodac" {
  provider      = docker.dacodac
  name          = data.docker_registry_image.audio-raat.name
  pull_triggers = [data.docker_registry_image.audio-raat.sha256_digest]
}

resource "docker_image" "raat-nightingale" {
  provider      = docker.nightingale
  name          = data.docker_registry_image.audio-raat.name
  pull_triggers = [data.docker_registry_image.audio-raat.sha256_digest]
}

resource "docker_container" "airport-croquette" {
  provider      = docker.dacodac
  name          = "airport"
  image         = docker_image.airport-croquette.latest

  restart       = "always"
  network_mode  = docker_network.dac_hackvlan.name

  env           = ["NAME=${var.airport_croquette}"]

  privileged    = true

  devices {
    host_path = "/dev/snd"
  }

  mounts {
    target  = "/var/lib/bluetooth"
    source = "/home/data/config/airport/bluetooth"
    read_only = false
    type    = "bind"
  }

/*
  devices {
    host_path = "/dev/ttyAMA0"
  }

  devices {
    host_path = "/dev/vcio"
  }

  devices {
    host_path = "/dev/vhci"
  }

  devices {
    host_path = "/dev/rfkill"
  }
*/

  capabilities {
    add  = ["NET_RAW", "NET_ADMIN"]
  }

}

resource "docker_container" "airport-nucomedon" {
  provider      = docker.nucomedon
  name          = "airport"
  image         = docker_image.airport-nucomedon.latest

  restart       = "always"
  network_mode  = docker_network.nuc_hackvlan.name

  env           = ["NAME=${var.airport_nucomedon}"]

  # XXX this shit is still necessary until we find a way to fix our soundcard mapping issue on the nuc
  command       = ["--", "-d", "hw:1"]

  devices {
    host_path = "/dev/snd"
  }
}


resource "docker_container" "airport-nightingale" {
  provider      = docker.nightingale
  name          = "airport"
  image         = docker_image.airport-nightingale.latest

  restart       = "always"
  network_mode  = "host"

  env           = ["NAME=${var.airport_nightingale}"]

  devices {
    host_path = "/dev/snd"
  }
}

resource "docker_container" "roon" {
  provider      = docker.nucomedon
  name          = "roon"
  image         = docker_image.roon.latest

  restart       = "always"
  network_mode  = docker_network.nuc_hackvlan.name

  mounts {
    target  = "/var/roon"
    source  = "/home/data/config/roon"
    read_only = false
    type    = "bind"
  }

  mounts {
    target  = "/music"
    source  = "/home/data/audio"
    read_only = true
    type    = "bind"
  }

  hostname = "roon-nucomedon"

  devices {
    host_path = "/dev/snd"
  }
}

resource "docker_container" "raat-dacodac" {
  provider      = docker.dacodac
  name          = "raat"
  image         = docker_image.raat-dacodac.latest

  restart       = "always"
  network_mode  = docker_network.dac_hackvlan.name

  mounts {
    target  = "/var/roon"
    source  = "/home/data/config/roon"
    read_only = false
    type    = "bind"
  }

  hostname = "raat-dacodac"

  devices {
    host_path = "/dev/snd"
  }
}

resource "docker_container" "raat-nightingale" {
  provider      = docker.nightingale
  name          = "raat"
  image         = docker_image.raat-nightingale.latest

  restart       = "always"
  # network_mode  = docker_network.nig_hackvlan.name
  # XXX host networking because fucking wifi
  network_mode  = "host"

  mounts {
    target  = "/var/roon"
    source  = "/home/data/config/roon"
    read_only = false
    type    = "bind"
  }

  hostname = "raat-nightingale"

  devices {
    host_path = "/dev/snd"
  }
}
