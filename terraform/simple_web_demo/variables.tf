variable "platform" {
  default     = "ubuntu"
  description = "The OS Platform"
}

variable "sg_name" {
  default     = "simple_web_demo"
  description = "The SG"
}


variable "user" {
  default = {
    ubuntu  = "ubuntu"
  }
}

variable "web-ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "

  default = {
    us-east-1-ubuntu        = "ami-0b715070"
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
  default     = "1"
  description = "The number of Consul servers to launch."
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
  default     = "web_servers"
  description = "Name tag for the servers"
}
