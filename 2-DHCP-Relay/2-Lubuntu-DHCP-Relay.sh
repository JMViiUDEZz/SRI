# Configurar gráficamente las interfaces

###################################################
#####-----Actualizar sistema-----##################
###################################################
apt update -y && apt upgrade -y

###################################################
###-----Instalar isc-dhcp-server-----##############
###################################################
apt install isc-dhcp-relay -y

echo 'INSTALACIONES COMPLETAS'

# Se puede configurar tanto graficamente al terminar la instalacion,
# como manualmente en el archivo /etc/default/isc-dhcp-relay.

########################################################
###-----Configuracion /etc/default/isc-dhcp-relay-----##
########################################################
echo 'SERVERS="192.168.8.1"'                      >  /etc/default/isc-dhcp-relay
echo 'INTERFACES="ens33 ens37'                    >  /etc/default/isc-dhcp-relay
echo 'OPTIONS=""'           			          >  /etc/default/isc-dhcp-relay

########################################################
###-----Comprobacion /etc/default/isc-dhcp-relay-----###
########################################################
cat /etc/default/isc-dhcp-relay
# El archivo de configuración se encuentra en /etc/default/