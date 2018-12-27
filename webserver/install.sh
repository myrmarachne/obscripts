#!/bin/bash

sudo apt-get update && sudo apt-get install -y apache2 git-core

iptables -I INPUT -p tcp --dport 80 -j ACCEPT

# Enabled the following apache modules
sudo a2enmod headers
sudo a2enmod ext_filter

git clone https://github.com/myrmarachne/obscripts

cd obscripts/webserver

# Append each of the configuration files to the main config file
for filename in ./*.conf; do
    cat "$filename" | sudo tee -a /etc/apache2/apache2.conf
done

sudo service apache2 restart
