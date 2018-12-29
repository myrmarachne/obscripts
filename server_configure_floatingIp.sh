#!/bin/bash

touch /root/server-ip
if [ $server_shared_int_network_floatingIp ]
then
    echo "$server_shared_int_network_floatingIp" > /root/server-ip
else
    echo "$server_private_floatingIp" > /root/server-ip
fi 
