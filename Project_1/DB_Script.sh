#!/usr/bin/bash

# MYSQL Setup script.

#Install Maria DB Package.

sudo yum update -y  
sudo yum install epel-release -y  
sudo yum install git mariadb-server zip unzip -y

#Starting & enabling mariadb-server.

sudo systemctl start mariadb
sudo systemctl enable mariadb

#Set db root password.
# Make sure that NOBODY can access the server without a password
sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('admin123') WHERE User = 'root'"
sudo systemctl restart mariadb
# disallow remote login for root.
sudo mysql -u root -padmin123 -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
# Kill the anonymous users.
sudo mysql -u root -padmin123 -e "DELETE FROM mysql.user WHERE User=''"
# Kill off the demo database test.
sudo mysql -u root -padmin123 -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
# Make our changes take effect.
sudo mysql -u root -padmin123 -e "FLUSH PRIVILEGES"


#Set DB name and users.
sudo mysql -u root -padmin123 -e "create database accounts;"
sudo mysql -u root -padmin123 -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -padmin123 -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' identified by 'admin123';"
sudo mysql -u root -padmin123 -e "FLUSH PRIVILEGES;"

#Download Source code & Initialize Database.
cd /tmp/
git clone -b main https://github.com/hkhcoder/vprofile-project.git
sudo mysql -u root -padmin123 accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo systemctl restart mariadb

#starting the firewall and allowing the mariadb to access from port no. 3306
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb

End

#sudo systemctl stop firewalld
#sudo systemctl disable firewalld
#sudo setenforce 0