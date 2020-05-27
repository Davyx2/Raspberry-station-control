#!/bin/bash

#-------------------------------------------------------------------------------------------------------------------------#
# Étape 6 - Execution du script 
#-------------------------------------------------------------------------------------------------------------------------#

USERNAME=$(awk -F= 'NR == 1 {print $2}' credential.txt)
PASSWORD=$(awk -F= 'NR == 2 {print $2}' credential.txt)
HOSTNAME=$(awk -F= 'NR == 3 {print $2}' credential.txt)

if [[ "$PWD" == "/home/pi/stream" ]] && [ -f "camera.sh" ] && [ -f "arduno.sh" ] && [ -f "main.sh" ]
then
    # Accept UDP connexion to 5000 on client monthabor 
    nc -l 5000
    chmod +x main.sh
    ./main.sh &
    exit
else
    if [[ "$PASSWORD" == " "]]; then
        scp -r $USERNAME@$HOSTNAME:/home/pi/stream /home/martin/QGroundControl 
    else
        sshpass -p "$PASSWORD" scp -r $USERNAME@$HOSTNAME:/home/pi/stream /home/martin/QGroundControl
    fi 
    cd /home/pi/stream/QGroundControl/boatRpiFiles
    chmod +x main.sh
    ./main.sh &
    exit
fi

exit
