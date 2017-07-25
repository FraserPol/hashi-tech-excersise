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


################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################


Scope and requirements;

1) Terraform provisions out Consul (this is avalible in the tutorial)
2) Slides to present and cover the various components and
advantages and selling points

--- Extra Points ---

1) HaProxy config to two Apache webservers that answer with their IPs - add in demo from Consul web portal
2) Packer to build out the Apache/HAProxy servers
3) Terraform to deploy and register with Consul
4) Figure out next steps here


###################

Build sript is semi working. Mac has a weird issue with sed. I've traced this down to a couple of
blog posts I need to read to understand the difference in Regexs. This is a side project to main goal.

I am happy with the consul cluster/Apache example but I think a good backup is ES cluster responding
with an index check for consul. This would give a more impactful demo.

Need to figure out where I can put Vault into demo and cluster. I think its best to do a KV example with ES hence the idea to change the basic demo.

Start working on slides soon TM.

##################

Ok majority of logic figured out. Modules present variables/inheritance so overrides are possible.

To do right now: add in health checks for single apache nodes (CM or remote-exec to be determined)

If using CM, search values/bootstrap to Chef and auto detect HA proxy values? Can this be done with Terraform?

Maybe switch to Redis/PostgreSQL to help with the next step of adding in keys

Start Slides SOON

##################

Did some quick Packer templates on base VMs to have Apache installed and HAProxy, next plan is to incorporate this into Terraform to provision out and discover the nodes automatically

Consul comes in here I suspect, I'll use the Consul git repo from the demo and switch to my AMIs or install myself? Not sure yet

####################

Follow up commit for code from tutorials and competitive information

#####################

Intial Commit, Set up Personal Account, Test Multiple SSH Config

########

Terraform tutorial notes;

1) Install Terraform through Brew
2) terraform apply = do /plan is show/destroy is yes
3) terraform provisions AMIs (from Packer)
4) Premium option is a workflow component
5) Variable definition is object.reference.value
6) consul example is in here


######

Consul tutorial notes;

1) Consul is installed as a binary (build into systems via Packer? Better to use Terraform example?)
2) Service discovery utility, http checks/outbound/inbound verification
3) Premiuim component?
4) Web consule/component is very attractive
