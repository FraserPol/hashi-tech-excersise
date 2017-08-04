module "network" {
  source = "./modules/network"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_instance" "web" {
    ami = "${lookup(var.web-ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    security_groups = ["${module.network.simple_web_demo}"]

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
        agent = false
    }

    #Instance tags
    tags {
        Name = "${var.tagName}-${count.index}"
    }

    provisioner "file" {
      source = "./website/example.html"
      destination = "/tmp/example.html"
    }

    provisioner "remote-exec" {
      inline = [
        "echo ${aws_instance.web.0.private_dns} > /tmp/example",
        "sudo mv /tmp/example.html /var/www/html/example.html"
      ]
    }

    provisioner "remote-exec" {
      script = "./scripts/ip_tables.sh"
    }
}

output "web_servers" {
  value = "${aws_instance.web.*.public_ip}"
}
