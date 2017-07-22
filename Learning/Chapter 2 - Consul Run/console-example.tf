provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "${var.region}"
}

module "consul" {
  source = "github.com/hashicorp/consul/terraform/aws"

  key_name = "fpollock_sa"
  key_path = "~/.ssh/id_rsa"
  region     = "${var.region}"
  servers  = "3"
}

output "consul_address" {
  value = "${module.consul.server_address}"
}

terraform {
  backend "consul" {
    address = "demo.consul.io"
    path    = "getting-started-randomerstring"
    lock    = false
  }
}
