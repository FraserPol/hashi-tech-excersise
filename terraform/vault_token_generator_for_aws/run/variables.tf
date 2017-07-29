variable "platform" {
  default     = "ubuntu"
  description = "The OS Platform"
}

variable "sg_name" {
  default     = "vault_token_demo"
  description = "The OS Platform"
}


variable "user" {
  default = {
    ubuntu  = "ubuntu"
  }
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "

  default = {
    us-east-1-ubuntu      = "ami-fcfea787"
  }
}

variable "service_conf" {
  default = {
    ubuntu  = "debian_upstart.conf"
  }
}

variable "service_conf_dest" {
  default = {
    ubuntu  = "upstart.conf"
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

variable "region" {
  default     = "us-east-1"
  description = "The region of AWS, for AMI lookups."
}

variable "servers" {
  default     = "3"
  description = "The number of Consul servers to launch."
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
  default     = "consul"
  description = "Name tag for the servers"
}
