#!/bin/bash

iface=enp2s0f5:1
meu_ip=192.168.0.3

sudo ifconfig $iface down
sudo ifconfig $iface $meu_ip netmask 255.255.255.0 up

#sudo route add -net 192.168.0.0 netmask 255.255.255.0 dev $iface
sudo route add -net 192.168.1.0 netmask 255.255.255.0 dev $iface
sudo route add -host 192.168.1.38 dev $iface reject

sudo route add -net 164.41.130.70 netmask 255.255.255.0 dev $iface

sudo route add default gw $meu_ip netmask 255.255.255.0 dev $iface

sudo echo 1 > /proc/sys/net/ipv4/ip_forward 

sudo iptables -t nat -A POSTROUTING -o $iface -j MASQUERADE

