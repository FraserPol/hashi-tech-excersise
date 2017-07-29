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

    provisioner "file" {
        source = "${path.module}/./scripts/${lookup(var.service_conf, var.platform)}"
        destination = "/tmp/${lookup(var.service_conf_dest, var.platform)}"
    }


    provisioner "remote-exec" {
        inline = [
            "echo ${var.servers} > /tmp/consul-server-count",
            "echo ${aws_instance.server.0.private_dns} > /tmp/consul-server-addr",
        ]
    }

    provisioner "remote-exec" {
        scripts = [
          "${path.module}/./scripts/install.sh",
          "${path.module}/./scripts/service.sh",
          "${path.module}/./scripts/ip_tables.sh",
        ]
    }



    provisioner "file" {
      source = "${path.module}/./website/index.html"
      destination = "/tmp/index.html"
    }

    provisioner "file" {
      source = "${path.module}/./env_configs/environment"
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
