resource "aws_instance" "server" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    security_groups = ["${aws_security_group.consul.name}"]

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
      source = "${path.module}/./vault_configs/basic-config.hcl"
      destination = "/tmp/config.hcl"
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
        "sudo mv /tmp/index.html /var/www/html/index.html",
        "sudo mv /tmp/config.hcl /opt/vault/config.hcl"
      ]
    }

    provisioner "remote-exec" {
      scripts = [
        "${path.module}/./scripts/install_vault.sh"
      ]
    }


}

resource "aws_security_group" "consul" {
    name = "consul_${var.platform}"
    description = "Consul internal traffic + maintenance."

    // These are for internal traffic
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }

    // These are for maintenance
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
