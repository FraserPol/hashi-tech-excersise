module "network" {
  source = "../modules/network"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
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

    provisioner "file" {
      source = "./aws/policy.json",
      destination = "/tmp/policy.json"
    }

    provisioner "file" {
      source = "./aws/s3policy.json"
      destination = "/tmp/s3policy.json"
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
        "sudo mv /tmp/index.html /var/www/index.html"
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
      "/tmp/unseal.sh ${var.aws_access_key} ${var.aws_secret_key}"
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

    provisioner "file" {
      source = "./haproxy/haproxy.cfg.ctmpl"
      destination = "/tmp/haproxy.cfg.ctmpl"
    }

    provisioner "remote-exec" {
      inline = [
        "sleep 30",
        "echo ${aws_instance.app.0.private_dns} > /tmp/consul-server-addr",
        "consul join $(cat /tmp/consul-server-addr | tr -d '\n')"
      ]
    }
}

output "app_servers" {
  value = "${aws_instance.app.*.public_ip}"
}

output "proxy" {
  value = "${aws_instance.proxy.*.public_ip}"
}
