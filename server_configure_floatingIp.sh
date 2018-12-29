#!/bin/bash

if [ $server_shared_int_network_floatingIp ]
then
    touch /root/server-ip
    echo "$server_shared_int_network_floatingIp" > /root/server-ip
    #screen -d -m -S client iperf -c $server_shared_int_network_floatingIp -t 20
else
    touch /root/server-ip
    echo "$server_private_floatingIp" > /root/server-ip
    #screen -d -m -S client iperf -c $server_private_floatingIp -t 20
fi 
