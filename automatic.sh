#!/bin/bash


<<<<<<< HEAD
sudo ufw allow 6000/tcp
sshpass -p "daviddavid" wanoon@192.168.50.107 bash -c "'
cd /home/wanoon/Apps/QGroundControl/boatRpiFiles/
python3 arduinoServer.py
'"
#'e
=======

IP=$(awk -F= ' NR == 4 {print $2}' credential.txt)
#
#---------------------------------------------------------------------------------------------------------------#
# Étape 0- Ouverture des ports
#---------------------------------------------------------------------------------------------------------------#
sudo ufw enable

sudo ufw default allow outgoing
sudo ufw default deny incoming

sudo ufw allow 14550/tcp
sudo ufw allow 5000/tcp
sudo ufw allow 5001/tcp
sudo ufw allow 5002/tcp
sudo ufw allow 5003/tcp


sudo ufw allow from $IP

sudo systemctl restart ufw.service &

echo "# Étape 0- Ouverture des ports  .... Fait\n" > logFile
#---------------------------------------------------------------------------------------------------------------#
# Étape 1 - Fixer l'adresse IP de l'ordinateur sur 192.168.0.120 .... 
#---------------------------------------------------------------------------------------------------------------#

sudo usermod -a -G sudo $USER

INTERFACE=$(awk -F= ' NR == 7 {print $2}' credential.txt)
file=$PWD/cfIp.yml
if [ -f "$file" ]; then
    cd /etc/netplan
    fileYML=$(ls | grep ".yaml")
    if [ -f "$fileYML" ]; then
        sudo cp $file /etc/netplan/${fileYML}
        cat $file
    fi
    sudo netplan apply
    ifconfig $INTERFACE | grep "inet"
fi
#echo "Étape 1 - Fixer l'adresse IP de l'ordinateur sur 192.168.0.120 .... Fait \n" >> logFile
#------------------------------------------------------------------------------------------------------------------#
# Étape 2 - Lancement de QGroundControl
#------------------------------------------------------------------------------------------------------------------#

#before automtic
cd $HOME/QGroundControl

id=$(id -u $USER)
if [ $id == 1000 ]
then echo "Your gps would probably disabled" >> logFile
else ./launch.sh &
fi

#you don't need to do this
cat logFile
echo "Étape 2 - Lancement de QGroundControl \n" >> logFile
#-------------------------------------------------------------------------------------------------------------------#
# Étape 3 - Connection au drone par UDP
#-------------------------------------------------------------------------------------------------------------------#


PORT=$(awk -F= ' NR == 5 {print $2}' credential.txt)
cd boatRpiFiles
sshpass -p $PASSWORD ssh $USERNAME@$HOSTNAME < udpServer.sh 
cd ../mainControl
nc $IP $PORT
./udpClient.sh &

cd
cd $HOME/QGroundControl
#run nc -l $PORT in raspery before next commant


echo "Étape 3 - Connection au drone par UDP  ....\n Fait" >> logFile
cat logFile
#-------------------------------------------------------------------------------------------------------------------#
# Étape 4 - Lancement de gstreamer en tant que client sur les ports 5000 et 5001
#-------------------------------------------------------------------------------------------------------------------#

# Verify if connexion tcp is established 


ping=$(ping 192.168.0.121 -c 2 | grep 64 | tail -n1)
T='64'
if [[ "$ping" == *"$T"* ]]; then
    echo "icmp request accept"
    cd /home/martin/QGroundControl/mainControl
    ls | grep "main.sh"
    chmod +x main.sh
    ./main.sh &
else
    ping $IP >> /home/${USER}/ping.txt
    echo "La rasperry pi est innacessible verifié la connexion internet \n" >> logFile
    exit
fi



echo "Étape 4 - Lancement de gstreamer en tant que client sur les ports 5000 et 5001 ... \n" >> logFile
#-------------------------------------------------------------------------------------------------------------------#
# Étape 5 - Connecter l'ordinateur au drone par SSH 
#-------------------------------------------------------------------------------------------------------------------#
cd
cd $HOME/QGroundControl/mainControl
python3 arduinoServer.py &

cd ..
USERNAME=$(awk -F= 'NR == 1 {print $2}' credential.txt)
PASSWORD=$(awk -F= 'NR == 2 {print $2}' credential.txt)
HOSTNAME=$(awk -F= 'NR == 3 {print $2}' credential.txt)

#verify if enabledpassword=false
pwd
if [[ "$PWD" == "/home/martin/QGroundControl" ]]; then
    if [ -z "$PASSWORD" ]; then
        ssh $USERNAME@$HOSTNAME < remoteRasp.sh 
    else
        SSH_COMMAND=$(sshpass -p $PASSWORD ssh $USERNAME@$HOSTNAME < remoteRasp.sh)
	    echo $SSH_COMMAND
	    exec $SSH_COMMAND
    fi
else 
    echo "Error: Accedez à /QgroundCOntrol puis acceder via ssh au rasperry pi.. \n" >> logFile
fi


echo "Étape 5 - Connecter l'ordinateur au drone par SSH ... \n Fait" >> logFile


#-------------------------------------------------------------------------------------------------------------------------#
# Étape 7 - Récupération des données envoyés par le raspberry pi sur le port 6000
#-------------------------------------------------------------------------------------------------------------------------#
echo "Welcome to Monthabor"


cat logFile
>>>>>>> 1a13aa1d92c74d0cdb9d2d16c04ba27568ec99bd
