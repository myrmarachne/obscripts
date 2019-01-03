#!/bin/bash

sudo apt-get update && sudo apt-get install -y apache2 git-core sysstat

iptables -I INPUT -p tcp --dport 80 -j ACCEPT

# Enabled the following apache modules
sudo a2enmod headers
sudo a2enmod ext_filter

git clone https://github.com/myrmarachne/obscripts

cd obscripts

# Create the directory with data
sudo mkdir /var/www/data

# Copy the data.zip file to data
sudo mv data.zip /var/www/data/data.zip

cd webserver

sudo mv apache2.conf /etc/apache2/apache2.conf

sudo service apache2 restart

# Configure the sysstat - enable data collecting
sudo sed -i -e 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat

sudo service sysstat restart
