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
        agent = false
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
        "consul join $(cat /tmp/consul-server-addr | tr -d '\n')",
        "sudo mv /tmp/ping.json /etc/consul.d/ping.json",
        "sudo mv /tmp/web.json /etc/consul.d/web.json",
        "sudo service consul reload",
        "chmod +x /tmp/unseal.sh",
        "consul join $(cat /tmp/consul-server-addr | tr -d '\n')"
      ]
    }
}

resource "null_resource" "configure-vault" {
  depends_on = ["aws_instance.server"]

  connection {
      user = "${lookup(var.user, var.platform)}"
      private_key = "${file("${var.key_path}")}"
      host = "${element(aws_instance.server.*.public_ip, 0)}"
      agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "/tmp/unseal.sh"
    ]
  }
}

resource "null_resource" "unseal-all" {
  depends_on = ["null_resource.configure-vault"]
  count = "${var.servers}"

  connection {
      user = "${lookup(var.user, var.platform)}"
      private_key = "${file("${var.key_path}")}"
      host = "${element(aws_instance.server.*.public_ip, count.index)}"
      agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "/tmp/unseal.sh"
    ]
  }
}

output "vault_token_demo" {
  value = "${aws_instance.server.*.public_ip}"
}
