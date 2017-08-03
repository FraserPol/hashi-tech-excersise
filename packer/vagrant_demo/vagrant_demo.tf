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
    "ami_name": "vagrant-{{isotime \"Mon 1504\"}}"
  }],

  "provisioners": [
    {
      "type": "file",
      "source": "webserver/index.html",
      "destination": "/tmp/index.html"
    },
    {
    "type": "shell",
    "inline": [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo mv /tmp/index.html /var/www/html/index.html"
    ]
    }
  ]
}
