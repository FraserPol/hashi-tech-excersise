#!/usr/bin/env bash
set -e
set -x

sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password password iamrootfearme'
sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again password iamrootfearme'

sudo apt-get -y install mysql-server-5.6

vault write database/config/mysql plugin_name=mysql-database-plugin connection_url="root:mysql@tcp(127.0.0.1:3306)/" allowed_roles="readonly"

vault write database/roles/readonly db_name=mysql creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';" default_ttl="1h" max_ttl="24h"
