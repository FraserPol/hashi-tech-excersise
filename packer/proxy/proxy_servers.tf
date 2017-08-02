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
    "ami_name": "proxy-server-{{isotime \"Mon 1504\"}}"
  }],
  "provisioners": [
    {
      "type": "file",
      "source": "scripts/consul_template.conf",
      "destination": "/tmp/consul_template.conf"
    },
    {
      "type": "file",
      "source": "consul_config/base.hcl",
      "destination": "/tmp/base.hcl"
    },
    {
      "type": "file",
      "source": "scripts/debian_upstart.conf",
      "destination": "/tmp/upstart.conf"
    },
    {
      "type": "file",
      "source": "haproxy/haproxy.cfg",
      "destination": "/tmp/haproxy.conf.ctmpl"
    },
    {
      "type": "file",
      "source": "haproxy/haproxy",
      "destination": "/tmp/haproxy"
    },
    {
    "type": "shell",
    "inline": [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y haproxy",
      "sudo mkdir -p /etc/consul_template.d/",
      "sudo mkdir -p /etc/consul.d/",
      "sudo mv /tmp/consul_template.conf /etc/init/consul_template.conf",
      "sudo mv /tmp/base.hcl /etc/consul_template.d/base.hcl",
      "sudo mv /tmp/haproxy /etc/default/haproxy",
      "sudo chmod -R 755 /etc/consul.d/"
      ]
    },
    {
      "type": "shell",
      "script": "scripts/install_consul_agent.sh"
    },
    {
      "type": "shell",
      "script": "scripts/install_consul_template.sh"
    }
  ]
}
