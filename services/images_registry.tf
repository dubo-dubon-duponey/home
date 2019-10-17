# System: router, logging
/*
data "docker_registry_image" "system-log" {
  name = "dubodubonduponey/logspout:v1"
}
*/

data "docker_registry_image" "logger" {
  name = "dubodubonduponey/filebeat:v1"
}

data "docker_registry_image" "dns" {
  name = "dubodubonduponey/coredns:v1"
}

data "docker_registry_image" "router" {
  name = "dubodubonduponey/caddy:v1"
}

data "docker_registry_image" "homekit-alsa" {
  name = "dubodubonduponey/homekit-alsa:v1"
}




data "docker_registry_image" "homebridge" {
  name = "dubodubonduponey/homebridge:v1"
}

data "docker_registry_image" "home-share" {
  name = "dubodubonduponey/netatalk:v1"
}





# Audio stuff
data "docker_registry_image" "audio-airport" {
  name = "dubodubonduponey/shairport-sync:v1"
}

data "docker_registry_image" "audio-raat" {
  name = "dubodubonduponey/roon-bridge:v1"
}

data "docker_registry_image" "audio-roon" {
  name = "dubodubonduponey/roon-server:v1"
}

# Home services
data "docker_registry_image" "video-plex" {
  name = "dubodubonduponey/plex:v1"
}

/*
data "docker_registry_image" "home-automation" {
  name = "dubodubonduponey/hass:v1"
}
*/





#data "docker_registry_image" "video-plex" {
#  name = "plexinc/pms-docker"
  #  name = "linuxserver/plex"
#}

data "docker_registry_image" "video-ombi" {
  name = "linuxserver/ombi"
}

# XXX need openvpn mixed into it
data "docker_registry_image" "network-transmission" {
  name = "linuxserver/transmission"
}

#data "docker_registry_image" "dev-gitlab" {
#  name = "gitlab/gitlab-ce:latest"
#}
