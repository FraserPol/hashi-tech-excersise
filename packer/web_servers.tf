{
  "variables": {
    "aws_access_key": "",
    "aws_secret_key": ""
  },
  "builders": [{
    "type": "amazon-ebs",
    "access_key": "{{user `aws_access_key`}}",
    "secret_key": "{{user `aws_secret_key`}}",
    "region": "us-east-1",
    "source_ami_filter": {
      "filters": {
      "virtualization-type": "hvm",
      "name": "*ubuntu-trusty-14.04-amd64-server-*",
      "root-device-type": "ebs"
      },
      "owners": ["099720109477"],
      "most_recent": true
    },
    "instance_type": "t2.micro",
    "ssh_username": "ubuntu",
    "ami_name": "fp-p-webserver-beta"
  }],
  "provisioners": [
    {
      "type": "file",
      "source": "consul_config/config.json",
      "destination": "/tmp/config.json"
    },
    {
      "type": "file",
      "source": "vault_config/vault.hcl",
      "destination": "/tmp/vault.hcl"
    },
    {
      "type": "file",
      "source": "vault_config/vault.conf",
      "destination": "/tmp/vault.conf"
    },
    {
    "type": "shell",
    "inline": [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo apt-get install -y unzip",
      "sudo mkdir /etc/consul.d/",
      "sudo mkdir /opt/vault/",
      "sudo mkdir /etc/vault.d/",
      "sudo chmod -R 0664 /var/www/html/",
      "sudo chmod -R 755 /etc/consul.d/",
      "sudo chmod -R 755 /opt/vault/",
      "sudo mv /tmp/config.json /etc/consul.d/config.json",
      "sudo mv /tmp/vault.hcl /etc/vault.d/vault.hcl",
      "sudo mv /tmp/vault.conf /etc/init/vault.conf"
    ]
    },
    {
      "type": "shell",
      "script": "scripts/install_vault.sh"
    },
    {
      "type": "shell",
      "script": "scripts/install_consul.sh"
    },
    {
      "type": "shell",
      "script": "scripts/ip_tables.sh"
    }
  ]
}
