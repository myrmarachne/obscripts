 #!/bin/bash

touch /root/cache-ip
echo $private_floatingIp > /root/cache-ip
IP_ADDR=$private_floatingIp

SERVER_IP_ADDR=`(sudo cat /root/server-ip)`

tmpfile=$(mktemp /tmp/squid.conf.XXXXXX)
CONFIG_FILE=/etc/squid3/squid.conf
DOMAINNAME=example_squid.net

cat >$tmpfile <<EOF 
# Set reverse proxy mode in squid
http_port 80 accel defaultsite=$DOMAINNAME vhost

# Set the web server 
cache_peer $SERVER_IP_ADDR parent 80 0 no-query originserver name=webserver

# Create access lists
acl webserver_users dstdomain example_squid.net $IP_ADDR

http_access allow webserver_users
cache_peer_access webserver allow webserver_users
http_access deny all

# Set memory cache options
maximum_object_size 150 MB
cache_mem 500 MB
maximum_object_size_in_memory 50000 KB
EOF

sudo mv $tmpfile $CONFIG_FILE
trap "rm -f '$tmpfile'" exit

echo $IP_ADDR $DOMAINNAME | sudo tee -a /etc/hosts

sudo service squid3 restart

# Configure the sysstat - enable data collecting
sudo sed -i -e 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat

sudo service sysstat restart
