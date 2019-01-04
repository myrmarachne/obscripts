#!/bin/bash

sudo apt-get update && sudo apt-get install -y apache2 git-core sysstat

iptables -I INPUT -p tcp --dport 80 -j ACCEPT
