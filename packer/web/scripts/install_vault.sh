#!/usr/bin/env bash

set -x
set -e

echo "Installing dependencies..."
if [ -x "$(command -v apt-get)" ]; then
  sudo apt-get update -y
  sudo apt-get install -y unzip
else
  sudo yum update -y
  sudo yum install -y unzip wget
fi

cd /tmp

wget "https://releases.hashicorp.com/vault/0.7.3/vault_0.7.3_linux_amd64.zip" -O vault.zip --quiet

unzip vault.zip

sudo mv vault /usr/local/bin/
sudo chmod +x /usr/local/bin/vault
sudo chmod 0755 /usr/local/bin/vault
sudo chown root:root /usr/local/bin/vault
