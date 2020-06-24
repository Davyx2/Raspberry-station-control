#!/usr/bin/env python
# -*- coding: utf-8 -*-
#usage: ./

import serial
import time
import sys
from pymavlink import mavutil
import socket

#ser = serial.Serial('/dev/ttyUSB0',9600)
#or:
#ser = serial.Serial('/dev/ttyACM0',9600)
#ser = serial.Serial('/dev/ttyAMA0',9600)
ser = serial.Serial('/dev/tty5',9600)
ser = serial.Serial('/dev/USB0',9600)
#or:
#ser = serial.Serial('/dev/ttyACM0',9600)
#ser = serial.Seriam('/dev/ttyAMA0', )

#parameter for TCP send
IP_BOAT = '192.168.50.107'
BUFFER_SIZE = 1024

TCP_PORT = 6001 # give 6000 here
print(IP_BOAT, TCP_PORT)

def convert(tuples):
    tab = []
    for i in range(0, len(tuples)):
        for j in range(0, len(tuples[i])):
            tab.append(tuples[i][j])
    return tab

try:
    sockArduino = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sockArduino.connect((IP_BOAT, TCP_PORT))
    print('Connection established to PC control:', (IP_BOAT))

    stored_exception = None

    while True:
        try:
            if stored_exception:
                break
            print("ici")
            arduinoSensors = ser.readline()
            arduinoSensors = convert(arduinoSensors) ### convert all information to tables
            print(arduinoSensors)
            #Send as a string
            for i in range(0, len(arduinoSensors)):
                sockArduino.send(str(arduinoSensors[i]).encode())
                time.sleep(2)
            data = sockArduino.recv(1024).decode()
            print("PCMonthabor #" + data )
            arduinoSensors = ser.readline()

        except KeyboardInterrupt:
            stored_exception=sys.exc_info()
    
    if stored_exception:
        raise stored_exception
finally:
    print('closing all')
    sockArduino.close()
     