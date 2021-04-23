#!/bin/bash

HOST=$1

SERVER=$2


REGISTER_HOST ()
{
echo "Insira o Endereço IPv4/Domínio:"

read IP

echo "Insira a Porta:"

read PORTA

echo "Insira o Usuário:"

read LOGIN

echo "Insira a Senha:"

read -s SENHA

echo "#!/bin/bash" > /var/script/teste/$HOST
echo "export IP=$IP" >> /var/script/teste/$HOST
echo "export PORTA=$PORTA" >> /var/script/teste/$HOST
echo "export LOGIN=$LOGIN" >> /var/script/teste/$HOST
echo "export SENHA=$SENHA" >> /var/script/teste/$HOST

chmod 777 /var/script/teste/$HOST

}



AUTO_SSH ()
{

        sshpass -p "$SENHA" ssh $LOGIN@$IP -p $PORTA 
}


if [ $HOST == list ];then
	ls -l  /var/script/teste/ |awk '{print $9}'
	exit
fi

ls /var/script/teste/$HOST 1> /dev/null 2> /dev/null 

if [ $? -eq 2 ]; then
        REGISTER_HOST
        AUTO_SSH
else
        source /var/script/teste/$HOST
        AUTO_SSH
fi





