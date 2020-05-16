#!/bin/bash

#---------------------------------------------------------------------#
# Étape 1 - Fixer l'adresse IP de l'ordinateur sur 192.168.0.120 .... 
#---------------------------------------------------------------------#


sudo usermod -a -G sudo $USER
#apt-get update -y
#apt-get install -y net-tools

file=$PWD/cfIp.yml
if [ -f "$file" ]; then
    cd /etc/netplan
    fileYML=$(ls | grep ".yaml")
    if [ -f "$fileYML" ]; then
        sudo cp $file /etc/netplan/${fileYML}
        cat $file
    fi
    sudo netplan apply
    ifconfig enx00e04a6a40c3 | grep "inet "
fi

#--------------------------------------------------------------------------#
# Étape 2 - Lancement de QGroundControl
#--------------------------------------------------------------------------#


cp QGroundControl.sh /usr/bin/
cp qGroundControl.desktop /home/${USER}/.config/autostart


#--------------------------------------------------------------------------#
# Étape 3 - Connection au drone par UDP
#--------------------------------------------------------------------------#

IP=$(awk -F= ' NR == 4 {print $2}' credential.txt)
PORT=$(awk -F= ' NR == 5 {print $2}' credential.txt)
nc $IP $PORT


#--------------------------------------------------------------------------#
# Étape 3 - Connection au drone par UDP
#--------------------------------------------------------------------------#

3. Lancement de gstreamer en tant que client sur les ports 5000 et 5001
#--------------------------------------------------------------------------#
# Étape 4 - Connecter l'ordinateur au drone par SSH 
#--------------------------------------------------------------------------#

USERNAME=$(awk -F= 'NR == 1 {print $2}' credential.txt)
PASSWORD=$(awk -F= 'NR == 2 {print $2}' credential.txt)
HOSTNAME=$(awk -F= 'NR == 3 {print $2}' credential.txt)

#verify if enabledpassword=false
sudo apt-get install sshpass
SSH_COMMAND=$(ssh $USERNAME@$HOSTNAME -fTN -R 2222:192.168.0.120:22 -i $HOME/.ssh/id_rsa)

if [[ -z $(ps -aux | grep "$SSH_COMMAND" | sed '$ d') ]]
then exec $SSH_COMMAND
else sshpass -p $PASSWORD ssh $USERNAME@$HOSTNAME
fi


#-------------------------------------------------------------------------------#
# Étape 5 - Lancement de gstreamer en tant que client sur les ports 5000 et 5001
#-------------------------------------------------------------------------------#
gst-launch-1.0 udpsrc port=5000 ! application/x-rtp,encoding-name=JPEG,payload=26 ! rtpjpegdepay ! jpegdec ! autovideosink

#--------------------------------------------------------------------------#
# Étape 6 - Execution du script 
#--------------------------------------------------------------------------#

cd /home/pi/stream

if [ $PWD == "/home/pi/stream" ] && [ -f "camera.sh" ] && [ -f "arduno.sh" ]
then
    chmod +x camera.sh
    ./camera.sh
    chmod +x arduino.sh
    ./arduino.sh
else
    echo "Une erreur s'est produite lors de l'éxécution du script" >> /home/${USER}/error.txt
fi



