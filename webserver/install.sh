#!/bin/bash

sudo apt-get update && sudo apt-get install -y apache2 git-core sysstat

iptables -I INPUT -p tcp --dport 80 -j ACCEPT

# Enabled the following apache modules
sudo a2enmod headers

git clone https://github.com/myrmarachne/obscripts

cd obscripts

# Create the directory with data
sudo mkdir /var/www/data

# Copy the data.zip file to data
sudo mv data.zip /var/www/data/data.zip
sudo mv sample.zip /var/www/data/sample.zip

cd webserver

sudo mv apache2.conf /etc/apache2/apache2.conf

sudo service apache2 restart

# Configure the sysstat - enable data collecting
sudo sed -i -e 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat

sudo service sysstat restart

# add cron rule

tmpfile=$(mktemp /tmp/cron.conf.XXXXXX)

cat >$tmpfile <<EOF 
# The first element of the path is a directory where the debian-sa1
# script is located
PATH=/usr/lib/sysstat:/usr/sbin:/usr/sbin:/usr/bin:/sbin:/bin

# Activity reports every 10 minutes everyday
*/1 * * * * root command -v debian-sa1 > /dev/null && debian-sa1 30 2

# Additional run at 23:59 to rotate the statistics file
59 23 * * * root command -v debian-sa1 > /dev/null && debian-sa1 60 2

EOF

sudo mv $tmpfile /etc/cron.d/sysstat
trap "rm -f '$tmpfile'" exit

sudo service cron restart
