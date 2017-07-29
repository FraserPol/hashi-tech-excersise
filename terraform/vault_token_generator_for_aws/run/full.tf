module "network" {
  source = "../modules/network"
}

resource "aws_instance" "server" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    security_groups = ["${module.network.vault_token_demo}"]

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    #Instance tags
    tags {
        Name = "${var.tagName}-${count.index}"
        ConsulRole = "Server"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.servers} > /tmp/consul-server-count",
            "echo ${aws_instance.server.0.private_dns} > /tmp/consul-server-addr",
        ]
    }

    provisioner "file" {
      source = "./scripts/debian_upstart.conf"
      destination = "/tmp/upstart.conf"
    }

    provisioner "remote-exec" {
    scripts = [
        "./scripts/install.sh",
        "./scripts/service.sh",
      ]
    }

    provisioner "file" {
      source = "./website/index.html"
      destination = "/tmp/index.html"
    }

    provisioner "file" {
      source = "./env_configs/environment"
      destination = "/tmp/environment"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo mv /tmp/environment /etc/environment",
        "sudo mv /tmp/ping.json /etc/consul.d/ping.json",
        "sudo mv /tmp/web.json /etc/consul.d/web.json",
        "sudo mv /tmp/index.html /var/www/html/index.html"
      ]
    }
}
