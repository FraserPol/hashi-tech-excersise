######################

Working Log
Scope and requirements;

1) Terraform provisions out Consul (this is avalible in the tutorial)
2) Slides to present and cover the various components and
advantages and selling points

--- Extra Points ---

1) HaProxy config to two Apache webservers that answer with their IPs - add in demo from Consul web portal
2) Packer to build out the Apache/HAProxy servers
3) Terraform to deploy and register with Consul
4) Figure out next steps here


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
