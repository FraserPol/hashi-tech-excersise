provider "aws" {
  access_key    = ""
  secret_key    = ""
  region        = "${var.region}"
}

resource "aws_instance" "web_node" {
  ami           = "${var.lb_ami}"
  instance_type = "${var.lb_it}"
  key_name      = ""
}

resource "aws_instance" "load_balancer" {
  ami           = "${var.lb_ami}"
  instance_type = "${var.lb_it}"
  depends_on    = ["aws_instance.web_node"]
}
