####################################################################
# Allows to configure generic aspects of the container.
# Usually, you want to specify hostname and networks and leave the rest to default
####################################################################

variable "hostname" {
  description = "Specifies the base hostname for the container to build its own hostname (=nickname.hostname)"
  type        = string
}

variable "networks" {
  description = "Map of networks to add the container to (key) and optional forced ip (value)"
  type        = map(string)
  default     = {}
}

variable "log" {
  description = "Whether to flag for filebeat log collection or not (defaults to true)"
  type        = bool
  default     = true
}

variable "dns" {
  description = "DNS server ip(s) to use for this container"
  type        = list(string)
  default     = []
}

variable "hosts" {
  description = "Additional hosts to feed the container"
  type        = map(string)
  default     = {}
}

variable "nickname" {
  description = "Overrides the container name (this is also used as a base to populate defaults for a number of other properties, like domain names)"
  type        = string
  default     = ""
}

variable "user" {
  description = "Overrides the unix user to run the container with (if set to 'root', will automatically add capabilities listed in defaults.tf)"
  type        = string
  default     = ""
}

variable "image" {
  description = "Overrides the docker image being used (format: owner/image) (also see 'registry')"
  type        = string
  default     = ""
}

variable "registry" {
  description = "Base registry from where to pull images (defaults to docker hub)"
  type        = string
  default     = "registry-1.docker.io"
}

variable "command" {
  description = "If specified, override command-line arguments to start the container with"
  type        = list(string)
  default     = []
}
