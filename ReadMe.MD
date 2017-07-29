######################

# How to Use

###########

## Pre-requisites and recommendations.

### Recommended Reading

* Getting started with [Packer](https://www.packer.io/intro/index.html)
* Getting started with [Terraform](https://www.terraform.io/)
* Getting started with [Consul](https://www.consul.io/intro/index.html)

################

1. [Install](https://www.packer.io/intro/getting-started/install.html) Packer
2. Inside /packer/ run `packer build web_servers.tf` this will provide an AMI for output, save this for later
3. [Install](https://www.terraform.io/intro/getting-started/install.html) Terraform
4. Inside /terraform/variables.tf paste your AMI id into the variable field "ami"
5. `terraform plan` to verify before run and `terraform get` to get the consul module
6. `terraform apply` to provision out cluster


This demo will provision a Consul cluster with packer images with Apache baked into the image.
For basic verification and check the IP of the machines is echo'ed into the index.html.

Once provisioned run `consul monitor` to see clustering status and HTTP status checks.

#################################################################################


To do:

1) Need to think about baking consul/vault into the build, what advantages/disadvantages does this present? (upgrades, maintenance, cluster joining, provision time over maintenance time, reusability)
2) Get vault working!
