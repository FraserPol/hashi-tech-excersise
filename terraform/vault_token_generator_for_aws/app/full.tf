module "network" {
  source = "../modules/network"
}

resource "aws_instance" "app" {
    ami = "${lookup(var.app-ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    security_groups = ["${module.network.vault_token_demo}"]

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
        agent = false
    }

    #Instance tags
    tags {
        Name = "${var.tagName}-${count.index}"
        ConsulRole = "Server"
    }

    provisioner "file" {
      source = "./website/index.html"
      destination = "/tmp/index.html"
    }

    provisioner "file" {
      source = "./consul_conf/web.json"
      destination = "/tmp/web.json"
    }

    provisioner "file" {
      source = "./consul_conf/ping.json"
      destination = "/tmp/ping.json"
    }

    provisioner "file" {
      source = "./scripts/unseal.sh"
      destination = "/tmp/unseal.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "echo ${var.servers} > /tmp/consul-server-count",
        "echo ${aws_instance.app.0.private_dns} > /tmp/consul-server-addr",
        "consul join $(cat /tmp/consul-server-addr | tr -d '\n')",
        "sleep 10",
        "consul kv put consul/primary/node $(cat /tmp/consul-server-addr)",
        "sudo mv /tmp/ping.json /etc/consul.d/ping.json",
        "sudo mv /tmp/web.json /etc/consul.d/web.json",
        "sudo service consul reload",
        "chmod +x /tmp/unseal.sh",
      ]
    }
}

resource "null_resource" "configure-vault" {
  depends_on = ["aws_instance.app"]
  count = "${var.servers}"

  connection {
      user = "${lookup(var.user, var.platform)}"
      private_key = "${file("${var.key_path}")}"
      host = "${element(aws_instance.app.*.public_ip, count.index)}"
      agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "/tmp/unseal.sh"
    ]
  }
}

resource "aws_instance" "proxy" {
    depends_on = ["null_resource.configure-vault"]

    ami = "${lookup(var.proxy-ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    security_groups = ["${module.network.vault_token_demo}"]

    tags {
        Name = "Demo Load Balancer"
    }

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
        agent = false
    }

    provisioner "remote-exec" {
      inline = [
        "echo ${aws_instance.app.0.private_dns} > /tmp/consul-server-addr",
        "consul join $(cat /tmp/consul-server-addr | tr -d '\n')",
      ]

    }

}

output "app_servers" {
  value = "${aws_instance.app.*.public_ip}"
}

output "proxy" {
  value = "${aws_instance.proxy.*.public_ip}"
}
