#!/bin/bash
# Created by Everton Agilar
# Date: 04/04/2016

iface_rede_unb=enp2s0f5
iface_rede_a=enp2s0f5:1

meu_ip=192.168.0.3
meu_ip_unb=164.41.130.70
netmask=255.255.255.0


start() {

	# levanta interfaces
	sudo ifconfig $iface_rede_unb $meu_ip_unb netmask $netmask up
	sudo ifconfig $iface_rede_a $meu_ip netmask $netmask up

	# adiciona as rotas
	sudo route add -net 192.168.1.0 netmask $netmask dev $iface_rede_a
	#sudo route add -net 164.41.130.70 netmask $netmask dev $iface_rede_unb

	# default gw
	sudo route add default gw $meu_ip netmask $netmask dev $iface_rede_a

	# habilita o roteamento
	sudo echo 1 > /proc/sys/net/ipv4/ip_forward 
	sudo iptables -t nat -A POSTROUTING -o $iface_rede_a -j MASQUERADE

	# rotas para rejeitar
	sudo route add -host 192.168.1.38 dev $iface_rede_a reject
}

stop() {
	sudo ifconfig $iface_rede_a down
	sudo ifconfig $iface_rede_unb down
	
	sudo route del -host 192.168.1.38 dev $iface_rede_a reject
}

case $1 in
  start|stop) "$1" ;;
esac
