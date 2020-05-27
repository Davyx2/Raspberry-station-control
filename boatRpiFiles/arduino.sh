#!/bin/bash

#launch arduino script which stream sensors data on port 6000
python arduinoSerial.py 6000 &
echo "launched Arduino Sensor stream"