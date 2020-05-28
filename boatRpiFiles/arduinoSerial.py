#!/usr/bin/env python
# -*- coding: utf-8 -*-
#usage: ./


import serial
import time
import sys
from pymavlink import mavutil
import socket

ser = serial.Serial('/dev/ttyUSB0',9600)
#or:
#ser = serial.Serial('/dev/ttyACM0',9600)
#ser = serial.Seriam('/dev/ttyAMA0', )

#parameter for TCP send
IP_BOAT = '192.168.0.121'
BUFFER_SIZE = 1024

TCP_PORT = int(sys.argv[1]) # give 6000 here
print(IP_BOAT, TCP_PORT)

try:
    sockArduino = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sockArduino.bind((IP_BOAT, TCP_PORT))
    sockArduino.listen(1)
    connArduino, addrArduino = sockArduino.accept()
    print('Connection address of arduino tcp connection:', addrArduino)

    stored_exception = None

    while True:
        try:
            if stored_exception:
                break
            arduinoSensors = ser.readline()
            print(arduinoSensors)
            connArduino.send((str(arduinoSensors)+';').encode())
        except KeyboardInterrupt:
            stored_exception=sys.exc_info()
    
    if stored_exception:
        raise stored_exception
finally:
    print('closing all')
    sockArduino.close()