# XXX It seems that docker_container.elastic.ip_address is racy...
#depends_on = [
#  docker_container.elastic
#]

module "elastic" {
  source = "./modules/elastic"
  providers = {
    docker = docker
  }

  hostname = var.hostname
  log = var.log
  networks = var.networks
  dns = var.dns
  user = var.user
  expose = var.expose

  registry = var.registry
}

module "kibana" {
  source = "./modules/kibana"
  providers = {
    docker = docker
  }

  hostname = var.hostname
  log = var.log
  networks = var.networks
  dns = var.dns
  user = var.user
  expose = var.expose

  elastic_container = "http://${module.elastic.name}:9200"

  registry = var.registry
}
