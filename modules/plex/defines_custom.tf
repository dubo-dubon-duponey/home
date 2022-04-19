variable "movie_path" {
  description = "Host path for mounted movie collection folder"
  type        = string
  default     = "/home/data/movie"
}

variable "public_ip" {
  description = "Plex publicly visible ip (defaults to myip.opendns.com)"
  type        = string
  default     = ""
}

// XXX check what this is and how to generalize
variable "email" {
  description = "Your email"
  type        = string
  default     = "you@me.com"
}
