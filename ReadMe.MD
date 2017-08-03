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
2. Inside /hashi-repo/packer/web run `packer build web_servers.tf` note the AMI that is created. Inside /hashi-repo/packer/proxy run `packer build proxy_servers.tf`
3. [Install](https://www.terraform.io/intro/getting-started/install.html) Terraform
4. Inside `/hashi-repo/terraform/vault_token_generator_for_aws/app/variables.tf` paste your AMIs id into the variable field "web_ami" and "proxy_ami"
5. `terraform plan` to verify before run and `terraform get` to get the various modules
6. `terraform apply` to provision out cluster


This demo will provision a Consul cluster with packer images with Apache baked into the image.

For basic verification and check the IP of the machines is echo'ed into the index.html.

Once provisioned run `consul monitor` to see clustering status and HTTP status checks.

On the proxy server to demo consul_template you can run;

`sudo nohup consul-template -template="/tmp/haproxy.cfg.ctmpl:/etc/haproxy/haproxy.cfg:service haproxy reload" >/dev/null 2>&1 &`

and by doing a `sudo service apache2 stop` on any web node you can show the clustering mechanism of Consul and the template feature/reload of haproxy.

#################################################################################
