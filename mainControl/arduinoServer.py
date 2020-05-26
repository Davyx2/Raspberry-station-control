import socket
import sys

IP_BOAT = '127.0.0.1'
TCP_PORT = int(sys.argv[1]) # give 6000 here

BUFFER_SIZE = 1024 

arduinoTCP = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
arduinoTCP.connect((IP_BOAT, TCP_PORT))

while True:
    arduinoData = arduinoTCP.recv(BUFFER_SIZE)
    if not arduinoData: break
    print(arduinoData.decode())
    #distArray = np.append(distArray,parseData(data.decode()))

    #conn.send(data)  # echo

arduinoTCP.close()
