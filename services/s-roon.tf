  #  mounts {
  #    target  = "/var/lib/bluetooth"
  #  source = "/home/data/config/airport/bluetooth"
  #  read_only = false
  #  type    = "bind"
  #}

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

resource "docker_container" "roon" {
  provider      = docker.nucomedon
  name          = "roon"
  image         = docker_image.roon.latest

  restart       = "always"
//  network_mode  = "host"
  user = "root"
  network_mode  = module.network-nuc.vlan

  mounts {
    target    = "/data"
    source    = "/home/data/config/roon"
    read_only = false
    type      = "bind"
  }

  mounts {
    target  = "/music"
    source  = "/home/data/audio"
    read_only = true
    type    = "bind"
  }

  hostname = "roon-nucomedon"

  /*
  devices {
    host_path = "/dev/snd"
  }
  */
}

