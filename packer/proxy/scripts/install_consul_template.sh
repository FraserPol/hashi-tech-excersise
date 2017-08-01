#!/usr/bin/env bash
set -e

set -x

echo "Installing dependencies..."
if [ -x "$(command -v apt-get)" ]; then
  sudo apt-get update -y
  sudo apt-get install -y unzip
else
  sudo yum update -y
  sudo yum install -y unzip wget
fi

wget https://releases.hashicorp.com/consul-template/0.19.0/consul-template_0.19.0_linux_amd64.zip -O consul_template.zip --quiet

sudo unzip consul_template.zip -d /usr/local/bin

sudo chmod 0755 /usr/local/bin/consul-template
sudo chown root:root /usr/local/bin/consul-template
sudo mkdir -p /etc/consul_template.d
sudo chmod 755 /etc/consul_template.d
sudo mkdir -p /opt/consul_template
sudo chmod 755 /opt/consul_template
