#!/bin/bash

#launch arduino script which stream sensors data on port 6000
python arduinoSerial.py 6000 &
echo "launched Arduino Sensor stream"

#launch cameraCycle.py, which handles the cycled camera stream on port 5000 and 50001, based on controller input.
python cameraCycle.py 2046 6001 &
echo "launched cycled camera streams"