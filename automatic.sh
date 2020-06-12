#!/bin/bash


sudo ufw allow 6000/tcp
sshpass -p "daviddavid" wanoon@192.168.50.107 bash -c "'
cd /home/wanoon/Apps/QGroundControl/boatRpiFiles/
python3 arduinoServer.py
'"
#'e
