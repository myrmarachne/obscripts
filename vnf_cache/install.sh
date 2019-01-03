#!/bin/bash

# Install squid
sudo apt-get update && sudo apt-get dist-upgrade && sudo apt-get install -y squid3 sysstat

# Configure the sysstat - enable data collecting
sudo sed -i -e 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat

sudo service sysstat restart


