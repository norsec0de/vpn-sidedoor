#!/bin/bash

if [ $# == 0 ]
then
    # Get the IP Address, Subnet Address, and Default Gateway for the first 'UP' adapter 
    nic="$(/sbin/ip addr | grep 'state UP' | awk '{ print $2 }' | cut -d':' -f1)"
    ip_address="$(/sbin/ip addr | grep 'state UP' -A2 | tail -n1 | awk '{ print $2 }' | cut -d'/' -f1)"
    subnet_address="$(/sbin/ip addr | grep 'state UP' -A2 | tail -n1 | awk '{ print $2 }' | sed -r 's:([0-9]\.)[0-9]{1,3}/:\10/:g')"
    default_gateway="$(/sbin/ip route | awk '/default/ { print $3 }')"
else
    # Get the IP Address, Subnet Address, and Default Gateway for the specified adapter 
    nic="$1"
    ip_address="$(/sbin/ip addr | grep ${nic}: -A2 | tail -n1 | awk '{ print $2 }' | cut -d'/' -f1)"
    subnet_address="$(/sbin/ip addr | grep ${nic}: -A2 | tail -n1 | awk '{ print $2 }' | sed -r 's:([0-9]\.)[0-9]{1,3}/:\10/:g')"
    default_gateway="$(/sbin/ip route | awk '/default/ { print $3 }')"
fi

# Configure the Route
/sbin/ip rule add from $ip_address table 128
/sbin/ip route add table 128 to $subnet_address dev $nic
/sbin/ip route add table 128 default via $default_gateway
