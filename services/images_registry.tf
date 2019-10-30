data "docker_registry_image" "router" {
  name = "dubodubonduponey/caddy:v1"
}

data "docker_registry_image" "log-frontend" {
  name = "dubodubonduponey/kibana:v1"
}






data "docker_registry_image" "log-backend" {
  name = "dubodubonduponey/elastic:v1"
}

data "docker_registry_image" "homebridge" {
  name = "dubodubonduponey/homebridge:v1"
}

data "docker_registry_image" "home-share" {
  name = "dubodubonduponey/netatalk:v1"
}

data "docker_registry_image" "audio-roon" {
  name = "dubodubonduponey/roon-server:v1"
}

# Home services
data "docker_registry_image" "video-plex" {
  name = "dubodubonduponey/plex:v1"
}


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
