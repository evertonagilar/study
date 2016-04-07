#!/bin/bash
# Created by Everton Agilar
# Date: 04/04/2016

iface_rede_unb=enp2s0f5
iface_rede_a=enp2s0f5:1

meu_ip=192.168.0.3
meu_ip_unb=164.41.130.70
netmask=255.255.255.0
meu_dns=164.41.101.4
meu_gw=164.41.130.1


start() {

	# **** rede unb *****
	
	# levanta interfaces
	ifconfig $iface_rede_unb $meu_ip_unb netmask $netmask up

	# adiciona as rotas
	#route add -host 164.41.101.4 dev $iface_rede_unb

	# habilita o roteamento e nat
	echo 1 > /proc/sys/net/ipv4/ip_forward 
	iptables -t nat -A POSTROUTING -o $iface_rede_unb -j MASQUERADE


	# **** rede a ****

	ifconfig $iface_rede_a $meu_ip netmask $netmask up
	route add -net 192.168.1.0 netmask $netmask dev $iface_rede_a

	# rotas para rejeitar
	route add -host 192.168.1.38 dev $iface_rede_a reject

	
	# cadastra os servidores dns
	if ! grep $meu_dns /etc/resolv.conf  ; then
		echo nameserver $meu_dns >> /etc/resolv.conf ;
	fi

	# default gw
	route add default gw $meu_gw netmask 0.0.0.0 dev $iface_rede_unb

	exit 0
}

stop() {
	route del -host 192.168.1.38 dev $iface_rede_a reject

	ifconfig $iface_rede_a down
	ifconfig $iface_rede_unb down
	
	exit 0
}

case $1 in
  start|stop) "$1" ;;
esac
