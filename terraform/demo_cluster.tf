#look at adding gcp or azure for fun

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "${var.region}"
}

#used the existing consul module

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
    user        = "ubuntu"
    host        = "${module.consul.server_address}"
    private_key = "${file("${var.key_path}")}"
    timeout     = "1m"
  }

#dropping in the web monitoring scripts, one to check access, one to check apache
#service and report into the demo

  provisioner "file" {
    source = "consul_conf/ping.json"
    destination = "/etc/consul.d/ping.json"
  }

  provisioner "file" {
    source = "consul_conf/web.json"
    destination = "/etc/consul.d/web.json"
  }

#to do: clean up perms

  provisioner "remote-exec" {
    inline = [
      "sudo ifconfig > /var/www/html/index.html",
      "service apache2 start",
      "consul reload"
    ]
  }
}

# got web servers up, now how to do clustering (could use CM for this)
# Edit: Serf says it can do this, add this to do
