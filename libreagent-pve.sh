#!/bin/bash


## Script para agilizar a implementação do agente Libvrenms ##
## Favor, ignore as gambiarras e o deslexo desse Sh ####




###### Checando todas a dependencias ########


echo "Checando as dependencias  ..."

sleep 5


INSTALL_DEP ()
{
        apt install $GIT $LIBPVE $SNMPD -y  
}

git --version 1> /dev/null 2> /dev/null

if [ $? -eq 0 ];
        then
               echo -e '\e[40;31;05m  Git já instalado !! \e[m'
else
        GIT=git
fi

dpkg --list libpve-apiclient-perl  1> /dev/null 2> /dev/null 

if [ $? == 1 ];then

        LIBPVE="libpve-apiclient-perl"
else
	echo -e '\e[40;31;05m libpve-apiclient-perl já instalado  !! \e[m'
fi



snmpd -v 1> /dev/null 2> /dev/null

if [ $? -eq 0 ];then
        echo -e '\e[40;31;05m  Snmp Já instalado !! \e[m'

else
        SNMPD=snmpd

fi


if [ $GIT $SNMPD $LIBPVE == "" ];then

        echo "Todas as dependecias já instaladas !!"
else
	INSTALL_DEP
fi

## Baixando codigo fonte do agente ##

echo " Baixando e instalando Agente LibreNMS ..."

sleep 5

mkdir -p /usr/lib/check_mk_agent/local/

git clone https://github.com/librenms/librenms-agent.git

cp -r  ./librenms-agent /opt/

cp -r /opt/librenms-agent/agent-local/proxmox /usr/lib/check_mk_agent/local/

chmod +x /usr/lib/check_mk_agent/local/proxmox

cp /opt/librenms-agent/check_mk@.service /opt/librenms-agent/check_mk.socket /etc/systemd/system


echo "Configurando Server..."

sleep 5

echo "Favor inserir a localização do HOST"

read LOCATION

echo "Favor inserir o contato técnico do HOST"

read CONTACT

echo "
rocommunity atplus.local 45.229.104.226

# setup info
syslocation  \" $LOCATION  \"
syscontact  \" $CONTACT \"

# open up
agentAddress  udp:161

# run as
agentuser  root

# dont log connection from UDP:
dontLogTCPWrappersConnects yes

# fix for disks larger then 2TB
realStorageUnits 0 "  > /etc/snmp/snmpd.conf


# Recarregando os Deamons para carregar o check_mk.socket
systemctl daemon-reload

# Adicionando na inicialização e colocando para executar
systemctl enable check_mk.socket && systemctl start check_mk.socket

# Reiniciando o SNMP service para recarregar as configurações feitas acima
systemctl restart snmpd.service


echo "Seu Agente Librenms-Proxmox já esta pronto !!! 
agora você só precisa adiciona-lo no monitoramento do seu Librenms e ativar o APP do Proxmox."

