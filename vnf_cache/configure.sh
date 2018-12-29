 #!/bin/bash

if [ $server_shared_int_network_floatingIp ]
then
    touch /root/server-ip
    echo "$server_shared_int_network_floatingIp" > /root/server-ip
    SERVER_IP_ADDR=$server_shared_int_network_floatingIp
else
    touch /root/server-ip
    echo "$server_private_floatingIp" > /root/server-ip
    SERVER_IP_ADDR=$server_private_floatingIp
fi

touch /root/cache-ip
if [ $private_floatingIp ]
then
    echo $private_floatingIp > /root/cache-ip
else
    echo $client_private_floatingIp > /root/cache-ip

fi


# TODO update with the floating IP
export IP_ADDR=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

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
