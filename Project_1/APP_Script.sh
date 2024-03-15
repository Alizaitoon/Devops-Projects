#!/usr/bin/bash

# TOMCAT Setup script.

# Install Dependencies.
sudo yum update -y  
sudo dnf install epel-release -y
sudo dnf -y install java-17-openjdk java-17-openjdk-devel
sudo dnf install git maven wget -y

# Download & Tomcat Package.
cd /tmp/
sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
sudo dnf install tar -y
sudo tar xzvf apache-tomcat-9.0.75.tar.gz
sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
sudo cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
sudo chown -R tomcat.tomcat /usr/local/tomcat
rm -rf /etc/systemd/system/tomcat.service

# Create tomcat service file.
sudo echo "[Unit]
Description=Tomcat
After=network.target
[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i
[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/tomcat.service

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

# CODE BUILD & DEPLOY (app01).

git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
sudo mvn install
sudo systemctl stop tomcat
sleep 20
sudo rm -rf /usr/local/tomcat/webapps/ROOT*
sudo cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
sudo systemctl start tomcat
sleep 20
sudo chown tomcat.tomcat /usr/local/tomcat/webapps -R
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl restart tomcat

End 


