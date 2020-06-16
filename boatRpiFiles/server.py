import socket
import sys


def Main():
    PORT = int(sys.argv[2])
    HOST = str(sys.argv[1])


    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.bind((HOST, PORT))

    print 'Starting connexion upd to QGroundControl'

    msg_send = "Connexion is ok"
    while True:
        data, addr = s.recvfrom(1024)
        data = data.decode('utf-8')
        print 'QGroundControl #' + str(data)
        if(str(data) == 'quit' or str(data )== 'exit'):
            exit
        else:
            s.sendto(msg_send.encode('utf8'), addr)
    s.close()

if __name__ == "__main__":
    Main()


