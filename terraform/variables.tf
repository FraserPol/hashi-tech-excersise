variable "region" {
  default     = "us-east-1"
  description        = "Region for cluster to spin up in"
}

variable "key_name" {
  default     = "fpollock_sa"
  description = "The AWS Key"
}

variable "key_path" {
  default     = "~/.ssh/id_rsa"
  description = "The path to the AWS Key"
}

variable "lb_ami" {
  default     = "ami-3dd7ca2b"
  description = "This is the default AMI for LB"
}

variable "lb_it" {
  default     = "t2.micro"
  description = ""
}
