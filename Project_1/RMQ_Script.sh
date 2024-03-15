#!/usr/bin/bash

# RABBITMQ Setup Script.

#Install Dependencies.
sudo yum update -y  
sudo yum install epel-release -y
sudo yum install wget -y

sudo yum -y install rabbitmq-server
sudo yum install erlang -y
sudo systemctl enable --now rabbitmq-server

# Setup access to user test and make it admin.
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server

# Starting the firewall and allowing the port 5672 to access rabbitmq.
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=5672/tcp
sudo firewall-cmd --runtime-to-permanent
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server

End


