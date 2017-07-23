variable "region" {
  default = "us-east-1"
}

variable "platform" {
  default = "ubuntu"
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "

  default = {
    us-east-1-ubuntu      = "ami-0987d672"
  }
}

variable "key_path" {
  description = "Default key path for connection"
  default     = "~/.ssh/id_rsa"
}

variable "key_name" {
  description = "AWS key name to access nodes"
  default     = "fpollock_sa"
}
