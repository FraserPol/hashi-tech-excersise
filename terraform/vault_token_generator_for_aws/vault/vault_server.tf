provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "${var.region}"
}

resource "aws_instance" "vault" {
  ami           = "ami-e783df9c"
  instance_type = "t2.micro"
  #this is to associate the key pair
  key_name = "${var.key_name}"

  connection {
    user        = "ubuntu"
    private_key = "${file("${var.key_path}")}"
  }

  
  provisioner "remote-exec" {
    scripts = [
      "./scripts/install_vault.sh"
    ]
  }
}
