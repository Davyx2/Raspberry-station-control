#!/bin/bash

#---------------------------------------------------------------------#
# Étape 1 - Fixer l'adresse IP de l'ordinateur sur 192.168.0.120 .... 
#---------------------------------------------------------------------#


sudo usermod -a -G sudo $USER


file=$PWD/cfIp.yml
if [ -f "$file" ]; then
    cd /etc/netplan
    fileYML=$(ls | grep ".yaml")
    if [ -f "$fileYML" ]; then
        sudo cp $file /etc/netplan/${fileYML}
        cat $file
    fi
    sudo netplan apply
    ifconfig wlo1 | grep "inet "
fi

#--------------------------------------------------------------------------#
# Étape 2 - Lancement de QGroundControl
#--------------------------------------------------------------------------#



