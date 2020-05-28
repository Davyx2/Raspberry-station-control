#!/bin/bash
cd /home/${USER}/

#Need to verify uid of uiser
uid=$(id -u  wanoon)

if [ $uid == 0 ]
then echo "you need to run this app with root user otherwise you can't get GPS"
else ./QGroundControl.AppImage &
fi
