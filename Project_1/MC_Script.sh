#!/usr/bin/bash

#MEMCACHE SETUP Script.

#Install, start & enable memcache on port 11211 .

sudo yum update -y  
sudo dnf install epel-release -y  
sudo dnf install memcached -y
sudo systemctl enable memcached --now
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo systemctl restart memcached
sudo firewall-cmd --add-port=11211/tcp
sudo firewall-cmd --runtime-to-permanent
sudo firewall-cmd --add-port=11111/udp
sudo firewall-cmd --runtime-to-permanent
sudo memcached -p 11211 -U 11111 -u memcached -d

End

