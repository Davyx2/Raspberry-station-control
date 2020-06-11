
import os, sys, socket
import tkinter as tk
from tkinter import ttk
import threading,  time


import tkinter
from tkinter import *

############ Config Window ##############
logo = "./favicon.ico"
top = tk.Tk()
top.config(bg="#4065A4")
top.geometry("1800x600")
top.minsize(1000, 300)
Twindow =any
#top.iconbitmap(logo)

top.title("Information réçu du capteurs")

##############  Menu Configuration ################
menu = Menu(top)

top.config(menu=menu)
filemenu = Menu(menu)
helpmenu = Menu(menu)

        
        
menu.add_cascade(label='File', menu=filemenu) 
menu.add_cascade(label='Help', menu=helpmenu)


filemenu.add_command(label='New') 
filemenu.add_command(label='Open...') 
filemenu.add_separator() 
filemenu.add_command(label='Exit', command=top.quit)
helpmenu.add_command(label='About')

############End Confirguration ###################

#192.168.50.107
class Server():
    def __init__(self):
        self.hostname = '192.168.0.120'
        self.port = 6000
        self.data = any
        self.alldata = ['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
        self.connect = False
    
    def getSocket(self):
        return socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def connected(self):
        s = self.getSocket()
        s.bind((self.hostname, self.port))
        s.listen()
        conn, addr = s.accept()
        print(addr)
        self.connect = True
        return conn


class Window():
    def __init__(self, master):
        self.width = 500
        self.height = 500
        self.B_stop = tk.Button(master, text="Close", width=15, fg = "red", command = self.quit).pack(side=BOTTOM, fill=Y, padx=2, pady=10 )
        self.B_Label = tk.Label(master, text="Information is Received , waiting to view it", bg='red', fg='white',font=("Courrier",10)).pack(side=BOTTOM, fill=Y)
        self.label = tk.Label(master, text="Information des capteurs", font=("Courrier",20, 'bold'), bg='gray', fg='black').pack(side=TOP) #grid(row=0, columnspan=10)
        self.cols = ('Time','Pressure(mbar)', 'Temperature(deg C)', 'Depth(m)', 'Altitude (m)', 'Humidité', 'Température',  'Humidité drone', 'Niveau d\'eau')
        self.Treeview = ttk.Treeview(master, columns=self.cols, show='headings')
        self.scrollbar = tk.Scrollbar(master, command=self.Treeview.yview).pack(side=RIGHT, fill=Y)
        self.Treeview.pack(side=LEFT , fill=BOTH)
        self.Treeview.config(yscrollcommand=self.scrollbar)
        self.tempList, self.isRunning, self.setup, self.Refresh, self.countRefresh = [['0','1','2','3','4','5','6','7']], False, 0, False, 0
        

#####quit interface Window Tkinter #############bg='red', fg='white',font=("Courrier",10)
    def quit(self):
        top.destroy()
        


################ Start Window ##################""
    def start(self):
        self.isRunning = True
        print("begin to update info in Treeview THread 2")
        
        Twindow = threading.Thread(target = self.measuredistance())
        Twindow.start()



###################  autorefresh Treeview ####################""
    def autoRefresh(self):
        self.show()
        self.isRefresh = True
        self.countRefresh += 1
        print(self.countRefresh)
    
############## Received data in Server and restart data Treeview ############
    def startServer(self):
        self.measuredistance()
        S = Server()  # An Instances of server
        conn = S.connected()          
        DATA = S.alldata
        while True:
            data = conn.recv(1024).decode('utf-8')
            if len(data) != 0:
                print('client# ', str(data))
                DATA.append(str(data))
                conn.send(data.encode('utf-8'))
                self.tempList = self.orderList(DATA)
                if len(self.tempList[0]) == 8:
                    #self.B_Label.configure(Text='Informationd send yet',bg='green', fg='white')
                    print(time.time())
                    self.show()    
        conn.close()


############## ordered data in bound to  eight element in a list########
    def orderList(self, list):
        l = []
        for i in range(0, len(list), 8):
            element = list[i:i+8]
            l.append(element)
        l = [l[-1]]
        return l


################# set header of Treeview ###################""""
    def setValue(self):
        for col in self.cols:
            self.Treeview.heading(col, text=col) 
        print('In setValue')


#################### Set data in lisbox ###################""
    def show(self):
        print('in show')
        self.tempList.sort(key=lambda e: e[1], reverse=False)
        for i, (a, b, c, d, e, f, g, h) in enumerate(self.tempList, start=0):
            self.Treeview.insert("", "end", values=(time.time(), a, b, c, d, e, f, g, h))



######### Démarer la conexion socket ################
    def lauchCom(self):
        Tcom = threading.Thread(target=self.startServer)
        Tcom.start()
        print('currrent thread', threading.current_thread())
        print('view all threating', threading.enumerate())
        

############### set both hearder and data to Treeview #########
    def measuredistance(self):
        self.setValue()
        self.show()
  
####### In
def returnLoop():
    print('start window mainloop')
    top.mainloop()

################## Main() ####################
def Main():
    W = Window(top)
    W.lauchCom()
    W.measuredistance()
    returnLoop()
    
 


if __name__ == "__main__":
    Main()