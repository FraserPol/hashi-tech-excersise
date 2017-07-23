provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "${var.region}"
}

module "consul" {
  source = "github.com/hashicorp/consul/terraform/aws"

  key_name    = "${var.key_name}"
  key_path    = "${var.key_path}"
  region      = "${var.region}"
  servers     = "3"
  ami         = "${var.ami}"

}

#doesn't look like you can use provisioners with modules so need to figure out
#how to act on my consul cluster after its been provisioned - https://github.com/hashicorp/terraform/issues/1240


resource "null_resource" "consul" {

  triggers {
    consul_instance_ids = "${module.consul.server_address}"
  }

  connection {
    user = "ubuntu"
    host = "${module.consul.server_address}"
    private_key = "${file("${var.key_path}")}"
    timeout = "1m"
  }

  provisioner "remote-exec" {
    inline = [
    "service apache2 start",
    ]
  }


}
