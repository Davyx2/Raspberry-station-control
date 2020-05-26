# -*- coding: utf-8 -*-
import serial #pip install pyserial
import time
import sys
import socket

NO_TCP_CONN = False

ser = serial.Serial('/dev/ttyACM0',9600)

#parameter for TCP send
TCP_IP = '192.168.0.121' #boatPi
TCP_PORT = int(sys.argv[1]) #give 6001
BUFFER_SIZE = 1024

print(TCP_IP, TCP_PORT)

def sendData(data, s):
    s.send(data.encode())

def initSocket():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((TCP_IP, TCP_PORT))
    return s

def closeSocket(s):
    s.close()

def streamCamControl(s):
    print("in stream")
    while True:
        read_serial=ser.readline()
        sendData(read_serial, s)


upSwVal = 52 ###TODO: recheck controller switch w/ print(camInstructions[0])
downSwVal = 53

print("before stream controller Button")
if not NO_TCP_CONN:
    s=initSocket()

while True:
    camInstructions = ser.readline()
   
    if NO_TCP_CONN:
        print(camInstructions[0])
    if (camInstructions[0]==downSwVal):
        #cycle down
        if not NO_TCP_CONN:
            print("cycle down")
            sendData("-1",s)
        print("-1")
    elif(camInstructions[0]==upSwVal):
        if not NO_TCP_CONN:
            print("cycle up")        
            sendData("1",s)
        print("1")



