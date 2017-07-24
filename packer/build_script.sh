#!/bin/bash

current_build=$(md5 ./web_servers.tf)
prev_build=$(cat current.txt)
name=$(md5 ./web_servers.tf | tail -c 7)

if [ "$current_build" = "$prev_build" ]
then
  echo "Nothing needed to change"
  echo $name > current.txt
else
 sed -i '' -e "s/ami_name.*/ami_name\": \"\\$name\"/g" ./web_servers.tf
fi
