#!/bin/bash

#ping=$(ping 192.168.50.23 -c 2 | grep 64 | tail -n1)
#echo $ping

ping=$(ping 192.168.50.23 -c 2 | grep 64 | tail -n1)
T='64'
if [[ "$ping" == *"$T"* ]]; then
  echo "It's there."
fi