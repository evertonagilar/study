#!/bin/bash
# Created by Everton Agilar
# Date: 04/04/2016

# Interfaces para cada rede
IFACE_REDE_UNB=enp2s0f5
IFACE_REDE_A=enp2s0f5:1
IFACE_REDE_B=enp2s0f5:2
IFACE_REDE_C=enp2s0f5:3

# O IPs de cada rede
IP_REDE_A=192.168.10.1
IP_REDE_B=192.168.15.1
IP_REDE_C=192.168.20.1
IP_REDE_UNB=164.41.130.70

REDE_A=192.168.10.0
REDE_B=192.168.15.0
REDE_C=192.168.20.0



NETMASK=255.255.255.0
DEFAULT_GW=164.41.130.1


start() {

	# **** Rede unb *****
	
	# levanta interfaces
	ifconfig $IFACE_REDE_UNB $IP_REDE_UNB netmask $NETMASK up

	# adiciona as rotas
	#route add -host 164.41.101.4 dev $IFACE_REDE_UNB

	# habilita o roteamento e nat
	echo 1 > /proc/sys/net/ipv4/ip_forward 
	iptables -t nat -A POSTROUTING -o $IFACE_REDE_UNB -j MASQUERADE


	# **** Rede A ****

	ifconfig $IFACE_REDE_A $IP_REDE_A netmask $NETMASK up

	route add -net 192.168.1.0 netmask $NETMASK dev $IFACE_REDE_A


	# default gw
	route add default gw $DEFAULT_GW netmask 0.0.0.0 dev $IFACE_REDE_UNB


	# **** Rede B ****
	
	ifconfig $IFACE_REDE_B $IP_REDE_B netmask $NETMASK up

	
	# **** Rede C ****
	
	ifconfig $IFACE_REDE_C $IP_REDE_C netmask $NETMASK up


	## Rotas
	
	#route add -net $REDE_A netmask 255.255.255.0 dev $IFACE_REDE_A
	#route add -net $REDE_B netmask 255.255.255.0 dev $IFACE_REDE_B
	#route add -net $REDE_C netmask 255.255.255.0 dev $IFACE_REDE_C


	# Rotas rejeitar

	#route add -host 192.168.1.38 dev $IFACE_REDE_A reject
	
		


	exit 0
}

stop() {
	route del -host 192.168.1.38 dev $IFACE_REDE_A reject

	ifconfig $IFACE_REDE_C down
	ifconfig $IFACE_REDE_B down
	ifconfig $IFACE_REDE_A down
	ifconfig $IFACE_REDE_UNB down
	
	exit 0
}

case $1 in
  start|stop) "$1" ;;
esac
