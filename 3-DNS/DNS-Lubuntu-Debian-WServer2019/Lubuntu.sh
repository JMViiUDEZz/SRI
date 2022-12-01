# * IP Debian: 10.33.8.3 * #
# * IP DNS Primario (Lubuntu): 10.33.8.2 * #
# * IP Router (Ipfire): 10.33.8.1 * #
# * IP WServer 2019: 10.33.8.4 * #

# Configurar las interfaces

#!/bin/bash
# Instalar paquetes
apt update -y
apt install bind9 -y
apt install nmap -y

###################################################
###-----Crear zonas secundarias y delegación-----##
###################################################

# * Aquí no hay que hacer nada para las delegaciones * #
echo "zone "barriosesamo.icv" {"                              >  /etc/bind/named.conf.local
echo "      type master;"                                     >> /etc/bind/named.conf.local
echo "      file "/etc/bind/db.barriosesamo.icv"; "           >> /etc/bind/named.conf.local
echo "      notify yes; "                                     >> /etc/bind/named.conf.local
echo "};"                                                     >> /etc/bind/named.conf.local

echo ""                                                       >> /etc/bind/named.conf.local

# Forma 2 de Crear un subdominio (Creando zona), no es necesario si hemos hecho la forma 1
echo "zone "quiosco.barriosesamo.icv" {"                      >> /etc/bind/named.conf.local
echo "      type master;"                                     >> /etc/bind/named.conf.local
echo "      file "/etc/bind/db.quiosco.barriosesamo.icv"; "   >> /etc/bind/named.conf.local
echo "      notify yes; "                                     >> /etc/bind/named.conf.local
echo "};"                                                     >> /etc/bind/named.conf.local

echo ""                                                       >> /etc/bind/named.conf.local

# Zona inversa
echo "zone "8.192.in-addr.arpa" {"                            >> /etc/bind/named.conf.local
echo "      type master;"                                     >> /etc/bind/named.conf.local
echo "      file "/etc/bind/db.192.8"; "                      >> /etc/bind/named.conf.local
echo "      notify yes; "                                     >> /etc/bind/named.conf.local
echo "};"                                                     >> /etc/bind/named.conf.local

###################################################
###---Crear configuracion de la DB de la zona----##
###################################################

echo ";"                                                                         >  /etc/bind/db.barriosesamo.icv 
echo '"$TTL"    86400'                                                           >> /etc/bind/db.barriosesamo.icv
echo "@     IN  SOA  lubuntu.barriosesamo.icv.  jose.barriosesamo.icv.  ("       >> /etc/bind/db.barriosesamo.icv
echo "                       3   ; Serial"                                       >> /etc/bind/db.barriosesamo.icv
echo "                  604800   ; Refresh"                                      >> /etc/bind/db.barriosesamo.icv
echo "                   86400   ; Retry"                                        >> /etc/bind/db.barriosesamo.icv
echo "                 2419200   ; Expire"                                       >> /etc/bind/db.barriosesamo.icv
echo "                    7200 ) ; Negative Cache TTL"                           >> /etc/bind/db.barriosesamo.icv
echo ";"                                                                         >> /etc/bind/db.barriosesamo.icv
echo "@         	IN  NS       lubuntu.barriosesamo.icv."                      >> /etc/bind/db.barriosesamo.icv
echo "@         	IN  NS       debian.barriosesamo.icv."                       >> /etc/bind/db.barriosesamo.icv
echo "lubuntu		IN  A        10.33.8.2"                                      >> /etc/bind/db.barriosesamo.icv
echo "debian       	IN  A        10.33.8.3"                                      >> /etc/bind/db.barriosesamo.icv
echo "espinete  	IN  A        192.8.0.101"                                    >> /etc/bind/db.barriosesamo.icv
echo "gustavo   	IN  A        192.8.0.102"                                    >> /etc/bind/db.barriosesamo.icv
echo "www       	IN  CNAME    espinete.barriosesamo.icv."                     >> /etc/bind/db.barriosesamo.icv
echo "mail      	IN  CNAME    gustavo.barriosesamo.icv."                      >> /etc/bind/db.barriosesamo.icv
echo "@         	IN  MX 10    gustavo.barriosesamo.icv."                      >> /etc/bind/db.barriosesamo.icv
echo ";"                                                                         >> /etc/bind/db.barriosesamo.icv # Subdominio delegado
echo "; subdominio laplaza delegado en w2019"                                    >> /etc/bind/db.barriosesamo.icv # Subdominio delegado
echo ";"                                                                         >> /etc/bind/db.barriosesamo.icv # Subdominio delegado
echo "laplaza.barriosesamo.icv.       IN  NS    w2019.laplaza.barriosesamo.icv." >> /etc/bind/db.barriosesamo.icv # Subdominio delegado
echo "w2019.laplaza.barriosesamo.icv. IN  A     10.33.8.4"                       >> /etc/bind/db.barriosesamo.icv # Subdominio delegado
#echo ";"                                                                        >> /etc/bind/db.barriosesamo.icv # Subdominio Forma 1 (Sin crear zona)
#echo "; subdominio quisko sin delegacion y sin zona nueva"                      >> /etc/bind/db.barriosesamo.icv # Subdominio Forma 1 (Sin crear zona)
#echo ";"                                                                        >> /etc/bind/db.barriosesamo.icv # Subdominio Forma 1 (Sin crear zona)
#echo "juan.quiosco  IN  A    192.8.0.151"                                       >> /etc/bind/db.barriosesamo.icv # Subdominio Forma 1 (Sin crear zona)
#echo "loli.quiosco  IN  A    192.8.0.152"                                       >> /etc/bind/db.barriosesamo.icv # Subdominio Forma 1 (Sin crear zona)

###################################################
#####-----Crear DB del subdominio (Forma 2)---#####
###################################################
echo ";"                                                                    >  /etc/bind/db.quiosco.barriosesamo.icv 
echo '"$TTL"    86400'                                                      >> /etc/bind/db.quiosco.barriosesamo.icv
echo "@     IN  SOA  lubuntu.barriosesamo.icv.  jose.barriosesamo.icv.  ("  >> /etc/bind/db.quiosco.barriosesamo.icv
echo "                       3   ; Serial"                                  >> /etc/bind/db.quiosco.barriosesamo.icv
echo "                  604800   ; Refresh"                                 >> /etc/bind/db.quiosco.barriosesamo.icv
echo "                   86400   ; Retry"                                   >> /etc/bind/db.quiosco.barriosesamo.icv
echo "                 2419200   ; Expire"                                  >> /etc/bind/db.quiosco.barriosesamo.icv
echo "                    7200 ) ; Negative Cache TTL"                      >> /etc/bind/db.quiosco.barriosesamo.icv
echo ";"                                                                    >> /etc/bind/db.quiosco.barriosesamo.icv
echo "@         IN  NS       lubuntu.barriosesamo.icv."                     >> /etc/bind/db.quiosco.barriosesamo.icv
echo "@         IN  NS       debian.barriosesamo.icv."                      >> /etc/bind/db.quiosco.barriosesamo.icv
echo "juan  	IN  A    	 192.8.0.151"                                   >> /etc/bind/db.quiosco.barriosesamo.icv
echo "loli  	IN  A    	 192.8.0.152"                                   >> /etc/bind/db.quiosco.barriosesamo.icv

###################################################
#####--------Crear DB de la zona inversa------#####
###################################################
echo ";"                                                                    >  /etc/bind/db.192.8 
echo '"$TTL"    86400'                                                      >> /etc/bind/db.192.8
echo "@     IN  SOA  lubuntu.barriosesamo.icv.  jose.barriosesamo.icv.  ("  >> /etc/bind/db.192.8
echo "                       3   ; Serial"                                  >> /etc/bind/db.192.8
echo "                  604800   ; Refresh"                                 >> /etc/bind/db.192.8
echo "                   86400   ; Retry"                                   >> /etc/bind/db.192.8
echo "                 2419200   ; Expire"                                  >> /etc/bind/db.192.8
echo "                    7200 ) ; Negative Cache TTL"                      >> /etc/bind/db.192.8
echo ";"                                                                    >> /etc/bind/db.192.8
echo "@         IN  NS       lubuntu.barriosesamo.icv."                     >> /etc/bind/db.192.8
echo "@         IN  NS       debian.barriosesamo.icv."                      >> /etc/bind/db.192.8
echo "101.0     IN  PTR      espinete.barriosesamo.icv."                    >> /etc/bind/db.192.8
echo "102.0     IN  PTR      gustavo.barriosesamo.icv."                     >> /etc/bind/db.192.8
echo "151.0     IN  PTR      juan.quiosco.barriosesamo.icv."                >> /etc/bind/db.192.8
echo "152.0     IN  PTR      loli.quiosco.barriosesamo.icv."                >> /etc/bind/db.192.8
echo "251.0     IN  PTR      farola.laplaza.barriosesamo.icv."              >> /etc/bind/db.192.8
echo "252.0     IN  PTR      papelera.laplaza.barriosesamo.icv."            >> /etc/bind/db.192.8

###################################################
#######-----------REENVIADORES-------------########
###################################################
# * Descomentar reenviadores porque lo pide el ejercicio * #
# * Comentamos para cuando tenemos que delegar en el server w2k19 * #

echo "options {"                              >  /etc/bind/named.conf.options
echo "        directory "/var/cache/bind";"   >> /etc/bind/named.conf.options
echo ""                                       >> /etc/bind/named.conf.options
echo "        //forwarders {"                 >> /etc/bind/named.conf.options
echo "        //        8.8.8.8;"             >> /etc/bind/named.conf.options
echo "        //        8.8.4.4;"             >> /etc/bind/named.conf.options
echo "        //};"                           >> /etc/bind/named.conf.options
echo ""                                       >> /etc/bind/named.conf.options
echo "        dnssec-validation auto;"        >> /etc/bind/named.conf.options
echo ""                                       >> /etc/bind/named.conf.options
echo "        listen-on-v6 { any; };"         >> /etc/bind/named.conf.options
echo "};"                                     >> /etc/bind/named.conf.options

###################################################
#######------------Comprobar-------------##########
###################################################
named-checkconf
echo "named-checkconf checked"

service bind9 restart

sleep 3

# Vaciar cachés
#systemd-resolve --flush-caches

named-checkconf -z
named-checkzone barriosesamo.icv /etc/bind/db.barriosesamo.icv
named-checkzone 8.192.in-addr.arpa /etc/bind/db.192.8
service bind9 restart
service bind9 status

# Comprobar que correos existen en un servidor
dig barriosesamo.icv MX

# Forma 2 de comprobar correos
#nslookup 
#   --> set type=MX 
#   --> barriosesamo.icv
#   --> exit

# Comprobar con el comando dig
# dig @IP(SERVIDOR NOMBRES QUE CONTESTA LA CONSULTA) NOMBRE-EQUIPO.ZONA

# Comprobar con el comando host
# host NOMBRE-EQUIPO.ZONA(ZONA DIRECTA)
# host IP-EQUIPO(ZONA INVERSA)