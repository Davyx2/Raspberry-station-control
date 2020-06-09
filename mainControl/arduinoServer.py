import os, sys, socket
import tkinter as tk
from tkinter import ttk
import threading


import tkinter
from tkinter import *

############ Config Window ##############
logo = "./favicon.ico"
top = tk.Tk()
top.config(bg="#4065A4")
top.geometry("1800x600")
top.minsize(1500, 600)
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
        s.listen(5)
        conn, addr = s.accept()
        print(addr)
        self.connect = True
        return conn


class Window():
    def __init__(self, master):
        self.width = 500
        self.height = 500
        self.B_view = tk.Button(master, text="Wiew", width=15, fg = "blue", command = self.start).pack(side=BOTTOM, padx=2, pady=10)    #.grid(row=4, column=0)
        #self.B_stop = tk.Button(master, text="Close", width=15, fg = "red", command = self.quit).pack(side=BOTTOM, fill=Y, padx=2, pady=10 )    #.grid(row=4, column=1)
        self.B_start = tk.Button(master, text="Demarrer le serveur", width=15, fg = 'green',  command = self.lauchCom).pack(side=BOTTOM, padx=2, pady=10 )
        #self.B_refresh = tk.Button(master, text="rafraichi", width=15, fg = "red", command = self.autoRefresh).pack(side=BOTTOM, fill=X, padx=2, pady=10 )
        self.label = tk.Label(master, text="Information réçu du capteurs", font=("Courrier",20), bg='red', fg='white').pack(side=TOP) #grid(row=0, columnspan=10)
        self.scrollbar = tk.Scrollbar(master).pack(side=RIGHT, fill=Y)
        self.cols = ('no','Pressure(mbar)', 'Temperature(deg C)', 'Depth(m)', 'Altitude (m)', 'Humidité', 'Température',  'Humidité drone', 'Niveau d\'eau')
        self.listBox = ttk.Treeview(master, columns=self.cols, show='headings')
        self.tempList, self.isRunning, self.setup, self.Refresh, self.countRefresh = [], False, 0, False, 0
        

#####quit interface Window Tkinter #############
    def quit(self):
        sys.exit()

################ Start Window ##################""
    def start(self):
        self.isRunning = True
        Twindow = threading.Thread(target = self.measuredistance)
        Twindow.start()

###################  autorefresh Listbox ####################""
    def autoRefresh(self):
        top.after(1000, self.autoRefresh)
        #print("list des threads")
        #print(threading.enumerate())
        self.isRefresh = True
        self.countRefresh += 1
        return self.countRefresh
    
############## Received data in Server and restart data listbox ############
    def startServer(self):
        S = Server()  # An Instances of server
        conn = S.connected()
        DATA = S.alldata
        while True:
            data = conn.recv(1024).decode('utf-8')
            if len(data) != 0:
                c = self.autoRefresh()
                DATA.append(str(data))
                conn.send(data.encode('utf-8'))
                self.tempList = self.orderList(DATA)
                print("Number Refresh:", c)
                #self.autoRefresh()
                print(self.tempList)
        conn.close()

############## ordered data in bound to  eight element in a list########
    def orderList(self, list):
        l = []
        for i in range(0, len(list), 8):
            element = list[i:i+8]
            l.append(element)
        l = [l[-1]]
        return l

################# set header of listbox ###################""""
    def setValue(self):
        for col in self.cols:
            self.listBox.heading(col, text=col) 
        self.listBox.pack(side=LEFT, fill=BOTH)
        print('In setValue')

#################### Set data in lisbox ###################""
    def show(self):   
        self.tempList.sort(key=lambda e: e[1], reverse=False)
        for i, (a, b, c, d, e, f, g, h) in enumerate(self.tempList, start=0):
            self.listBox.insert("", "end", values=(i, a, b, c, d, e, f, g, h))
        self.setup += 1
        print(self.setup)


######### Démarer la conexion socket ################
    def lauchCom(self):
        Tcom = threading.Thread(target=self.startServer)
        Tcom.start()
        print(threading.current_thread())

############### set both hearder and data to listbox #########
    def measuredistance(self):
        #self.tempList.remove()
        self.setValue()
        self.show()
  
####### In
def returnLoop():
    top.mainloop()


def Main():
    W = Window(top)  # An Instances of Window
    returnLoop()
 



if __name__ == "__main__":
    Main()
