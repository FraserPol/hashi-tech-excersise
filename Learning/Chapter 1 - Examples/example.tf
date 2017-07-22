provider "aws" {
#  access_key = "${var.access_key}"
  access_key = ""
  secret_key = ""
  region     = "${var.region}"
}

#provisioner is a substitute for packer? need to define this

resource "aws_instance" "example" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  key_name = "fpollock_sa"
}

resource "aws_instance" "another" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  key_name = "fpollock_sa"
}

# aws_instance.example.id is grabbing the id of this instance
# and populating it inside that value
# its variable interpolation

#depends_on is explicit declaration of dependance (this is assumed)
#doesnt need to be declared
#terraform graph will show

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
  depends_on = ["aws_instance.example"]
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}
