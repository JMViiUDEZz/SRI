# Configurar las interfaces

#!/bin/bash
# Instalar paquetes
apt update -y
apt install bind9 -y
apt install nmap -y

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del lubuntu
echo "zone "barriosesamo.icv" {"                      >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file "db.barriosesamo.icv"; "             >> /etc/bind/named.conf.local
echo "      masters {10.33.8.2;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del lubuntu
echo "zone "quiosco.barriosesamo.icv" {"              >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file "db.quiosco.barriosesamo.icv"; "     >> /etc/bind/named.conf.local
echo "      masters {10.33.8.2;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del lubuntu
echo "zone "laplaza.barriosesamo.icv" {"              >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file "db.laplaza.barriosesamo.icv"; "     >> /etc/bind/named.conf.local
echo "      masters {10.33.8.4;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del lubuntu
echo "zone "8.192.in-addr.arpa" {"                    >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file "db.192.8"; "                        >> /etc/bind/named.conf.local
echo "      masters {10.33.8.2;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

# Comprobar que se ha transferido todo correctamente
ls -al /var/cache/bind