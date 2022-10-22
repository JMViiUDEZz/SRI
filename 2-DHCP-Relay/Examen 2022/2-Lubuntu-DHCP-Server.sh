#!/bin/bash

# Configurar gráficamente las interfaces

###################################################
#####-----Actualizar sistema-----##################
###################################################
apt update -y && apt upgrade -y

###################################################
###-----Instalar isc-dhcp-server e iptables-----###
###################################################
apt install isc-dhcp-server iptables -y

echo 'INSTALACIONES COMPLETAS'

###################################################
#####-----Copia de DHCPd.conf.original--------#####
###################################################
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.original

###################################################
#####-----Configuracion Global DHCPd.conf-----#####
###################################################
echo 'COMIENDO DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

echo 'ddns-update-style none;'                      >  /etc/dhcp/dhcpd.conf 

echo '' >> /etc/dhcp/dhcpd.conf 

echo 'default-lease-time 6000;'                     >> /etc/dhcp/dhcpd.conf 
echo 'max-lease-time 7200;'                         >> /etc/dhcp/dhcpd.conf 

echo ''                                             >> /etc/dhcp/dhcpd.conf 

#####--------------VMNet2 172.8.0.0--------------#####
echo 'subnet 172.8.0.0 netmask 255.255.128.0 {'     >> /etc/dhcp/dhcpd.conf 
echo '  range 172.8.1.1 172.8.8.254;'             	>> /etc/dhcp/dhcpd.conf 
echo '  option routers 172.8.0.1;'                  >> /etc/dhcp/dhcpd.conf 
echo '  option domain-name-servers 1.1.1.1;'        >> /etc/dhcp/dhcpd.conf 
echo '  default-lease-time 43200;'                 	>> /etc/dhcp/dhcpd.conf 
echo '}'                                            >> /etc/dhcp/dhcpd.conf

echo ''                                             >> /etc/dhcp/dhcpd.conf 

#####--------------VMNet3 192.168.8.0--------------#####
echo 'subnet 192.168.8.0 netmask 255.255.255.128 {' >> /etc/dhcp/dhcpd.conf 
echo '  range 192.168.8.62 192.168.8.126;'          >> /etc/dhcp/dhcpd.conf 
echo '  option routers 192.168.8.1;'                >> /etc/dhcp/dhcpd.conf 
echo '  option domain-name-servers 9.9.9.9;'    	>> /etc/dhcp/dhcpd.conf
echo '  default-lease-time 21600;'                 	>> /etc/dhcp/dhcpd.conf 
echo '}'                                            >> /etc/dhcp/dhcpd.conf

echo ''                                             >> /etc/dhcp/dhcpd.conf 

#####--------------Reserva de IPs---------------#####
echo 'host Cli-W10 {'                               >> /etc/dhcp/dhcpd.conf 
echo '  hardware ethernet 00:11:22:33:44:55;'       >> /etc/dhcp/dhcpd.conf 
echo '  fixed-address 172.8.1.0;'                  	>> /etc/dhcp/dhcpd.conf 
echo '}'                                            >> /etc/dhcp/dhcpd.conf

echo 'FIN DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

###################################################
##--Configuracion /etc/default/isc-dhcp-server--###
###################################################
# * IMPORTANTE COMPROBAR CUALES SON LAS INTERFACES * #
echo 'COMIENZO DE LA CONFIGURACION EN /etc/default/isc-dhcp-server'

echo INTERFACESv4="ens33"                     		>  /etc/default/isc-dhcp-server
echo INTERFACESv6=""                                >> /etc/default/isc-dhcp-server

echo 'FIN DE LA CONFIGURACION EN /etc/default/isc-dhcp-server'

###################################################
####----Configuracion /etc/dhcp/sysctl.conf----####
###################################################
echo 'net.ipv4.ip_forward=1'                        > /etc/sysctl.conf

###################################################
#########------IPTABLES PARA NAT-----##############
###################################################
echo 'COMIENZO DE LA CONFIGURACION IPTABLES /etc/default/isc-dhcp-server.conf'
sleep 2
sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
echo 'FIN DE LA CONFIGURACION IPTABLES /etc/default/isc-dhcp-server.conf'
sleep 2

###################################################
#########--------RELEER SYSCTL-------##############
###################################################
sysctl -p /etc/sysctl.conf

service isc-dhcp-server restart

sleep 2

service isc-dhcp-server status

echo '¡TODO LISTO!'