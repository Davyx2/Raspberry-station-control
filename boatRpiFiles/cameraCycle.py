import os
import time
import sys
import subprocess
import socket

"""
in boat's rpi, switch between camera stream, always on the same port
"""
print("starting cycle camera script")

FPV_CAM_ID = sys.argv[1]
RIGHT_CAM_ID = sys.argv[2]
LEFT_CAM_ID = sys.argv[3]
BACK_CAM_ID = sys.argv[4]

CAM_ID_ARRAY = [RIGHT_CAM_ID, LEFT_CAM_ID, BACK_CAM_ID] #0: RIGHT | 1: LEFT | 2: BACK |

GSTREAM_PORT = 5001 #FPV cam : 5000

IP_BOAT = '192.168.0.121'
IP_OPERATOR = '192.168.0.120'
TCP_CYCLED_SW_PORT = int(sys.argv[5]) #give 6001 here
GST_FPV_PORT = 5000
GST_CYCLED_CAM_PORT = 5001
BUFFER_SIZE = 1024

CYCLE_SW_ACTIVE = True

def kill(pid):
    os.system("kill %s"%(str(pid)))

controllerInstruct = ""
pidFPV = None
pidCycle = None

try:
    sockController = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sockController.bind((IP_BOAT, TCP_CYCLED_SW_PORT))
    sockController.listen(1)
    connController, addrController = sockController.accept()
    print('Connection address controller:', addrController)


    #open FPV camera stream
    fpvCam = subprocess.Popen(['gst-launch-1.0 v4l2src device=/dev/video%s ! rtpjpegpay ! udpsink host=%s port=%s'%(FPV_CAM_ID,IP_OPERATOR,GST_FPV_PORT)], shell=True)
    pidFPV = subprocess.check_output("pidof gst-launch-1.0", shell=True)
    #set current cycled camera to the RIGHT one
    currentCamID = 0
    #open RIGHT camera stream ()
    cycledCam = subprocess.Popen(['gst-launch-1.0 v4l2src device=/dev/video%s ! rtpjpegpay ! udpsink host=%s port=%s'%(CAM_ID_ARRAY[currentCamID],IP_OPERATOR,GST_CYCLED_CAM_PORT)], shell=True)
    pidCycle = subprocess.check_output("pidof gst-launch-1.0", shell=True)
    [pidCycle,pidFPV]=pidCycle.split()
    print("pidFPV:", pidFPV)
    print("pidCycle:", pidCycle)

    stored_exception = None

    while True:
        try:
            if stored_exception:
                break
            if CYCLE_SW_ACTIVE:
                controllerInstruct = connController.recv(BUFFER_SIZE).decode()

            if (controllerInstruct=="1"):
                #cycle camera upwards
                kill(pidCycle) #stop current cycled camera
                #time.sleep(1)
                currentCamID += 1 #cycle up
                currentCamID = currentCamID%3 #there are 3 cameras to cycle, therefore currentCamID is modulo 3
                print(currentCamID)
                cycledCam = subprocess.Popen(['gst-launch-1.0 v4l2src device=/dev/video%s ! rtpjpegpay ! udpsink host=%s port=%s'%(CAM_ID_ARRAY[currentCamID],IP_OPERATOR,GST_CYCLED_CAM_PORT)], shell=True)
                pidCycle = subprocess.check_output("pidof gst-launch-1.0", shell=True)
                [pidCycle,pidFPV]=pidCycle.split()
                print("pidFPV:", pidFPV)
                print("pidCycle:", pidCycle)

            elif (controllerInstruct == "-1") :
                #cycle camera downwards
                kill(pidCycle) #stop current cycled camera
                #time.sleep(1)
                currentCamID -= 1 #cycle down
                currentCamID = currentCamID%3 #there are 3 cameras to cycle, therefore currentCamID is modulo 3
                print(currentCamID)
                cycledCam = subprocess.Popen(['gst-launch-1.0 v4l2src device=/dev/video%s ! rtpjpegpay ! udpsink host=%s port=%s'%(CAM_ID_ARRAY[currentCamID],IP_OPERATOR,GST_CYCLED_CAM_PORT)], shell=True)
                pidCycle = subprocess.check_output("pidof gst-launch-1.0", shell=True)
                [pidCycle,pidFPV]=pidCycle.split()
                print("pidFPV:", pidFPV)
                print("pidCycle:", pidCycle)

        except KeyboardInterrupt:
            stored_exception=sys.exc_info()

    if stored_exception:
        raise stored_exception
finally:
    sockController.close()

os.system("pkill -f gst-launch-1.0")
sys.exit()