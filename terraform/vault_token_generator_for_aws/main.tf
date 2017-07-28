#including the pre-built consul module to show off monitor/state

module "consul" {
  source = "./consul"
}

#self built vault module to demonstrate the hardware token replication

module "vault" {
  source = "./vault"
}
