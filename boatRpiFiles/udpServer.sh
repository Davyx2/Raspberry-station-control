#!/bin/bash

#################################################
#  Starting UDP on Raspberry pi  5001
#################################################
IS_USED=$(sudo netstat -lnpt |grep 5001 | awk -F"      " ' NR == 1 {print $8}' | awk -F"/" '{print $1}') 
if [[ -z "$IS_USED" ]]; then 
    #nc $IP $PORT
    python server.py 192.168.0.121 5001 &
    exit
else
    kill -9 $IS_USED
    python server.py 192.168.0.121 5001 &
    exit
fi

