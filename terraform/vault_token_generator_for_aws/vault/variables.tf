variable "region" {
  default = "us-east-1"
}

variable "platform" {
  default = "ubuntu"
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "

  default = {
    us-east-1-ubuntu = "ami-e783df9c"
  }
}

variable "key_path" {
  description = "Default key path for connection"
  default     = "~/.ssh/id_rsa_personal"
}

variable "key_name" {
  description = "AWS key name to access nodes"
  default     = "id_rsa_personal"
}
