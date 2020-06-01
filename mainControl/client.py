import os, socket, sys

def Main():
    PORT = int(sys.argv[2])
    HOST = str(sys.argv[1])

    raspberry = (HOST, 5001)

    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.bind((HOST, PORT))

    message = input('-->')
    while message != 'q':
        s.sendto(message.encode('utf-8'), raspberry)
        data, raspberry = s.recvfrom(1024)
        data = data.decode('utf-8')
        print("Raspberry #" + str(data))
    s.close()

if __name__ == "__main__":
    Main()