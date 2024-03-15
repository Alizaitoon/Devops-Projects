#!/usr/bin/bash

# NGINX Setup script.

# Install nginx .
sudo apt-get update -y 
sudo apt-get upgrade -y
sudo apt-get install nginx -y

# Create Nginx conf file.

sudo echo "upstream vproapp {
server app01:8080;
}
server {
listen 80;
location / {
proxy_pass http://vproapp;
}
}" >> /etc/nginx/sites-available/vproapp
sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

End


