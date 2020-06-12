
import os, sys, socket
import tkinter as tk
from tkinter import ttk
import threading,  time

import tkinter
from tkinter import *
from tkinter import messagebox as mb
############ Config Window ###############4065A4
logo = "./favicon.ico"
top = tk.Tk()
top.config(bg="cyan")
top.geometry("1800x600")
top.minsize(1000, 300)
Twindow =any
#top.iconbitmap(logo)

top.title("MONTHABOR ")

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
        self.alldata = ['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17']
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
        self.B_Label = tk.Label(master, text="Information is Received , waiting to view it", bg='green', fg='white',font=("Courrier",10)).pack(side=BOTTOM, fill=Y)
        self.label = tk.Label(master, text="Information des capteurs", font=("Calibri",20, 'bold'), bg='#4065A4', fg='white').pack(side=TOP) #grid(row=0, columnspan=10)
        self.cols = ('Time','Pressure(mbar)', 'Temperature(C)', 'Depth(m)', 'Altitude(m)', 'Humidité(BE)', 'Température(BE)',  'Humidité(D)', 'Temperature(D)', 'Niveau d\'eau')
        self.Treeview = ttk.Treeview(master, columns=self.cols, show='headings')
        self.scrollbar = tk.Scrollbar(master, command=self.Treeview.yview).pack(side=RIGHT, fill=Y)
        self.Treeview.pack(side=LEFT , fill=BOTH)
        self.Treeview.config(yscrollcommand=self.scrollbar)
        self.tempList, self.isRunning, self.setup, self.Refresh, self.countRefresh = [['0','1','2','3','4','5','6','7','8']], False, 0, False, 0
        

#####quit interface Window Tkinter #############bg='red', fg='white',font=("Courrier",10)
    def quit(self):
        res=mb.askquestion('Exit Application', 'if yuou do this the raspberry will be disconnected')
        if res == 'yes':
            top.destroy()
        else:
            mb.showinfo('Return', 'Returning to main application')
        


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
            data = conn.recv(1024).decode()
            if len(data) != 0:
                print('client# ', str(data))
                DATA.append(str(data))
                conn.send(data.encode())
                self.tempList = self.orderList(DATA)
                if len(self.tempList[0]) == 9:
                    print(time.time())
                    self.show()    
        conn.close()


############## ordered data in bound to  eight element in a list########
    def orderList(self, list):
        l = []
        for i in range(0, len(list), 9):
            element = list[i:i+9]
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
        temps = time.asctime(time.localtime(time.time()))
        self.tempList.sort(key=lambda e: e[1], reverse=False)
        for i, (a, b, c, d, e, f, g, h, k) in enumerate(self.tempList, start=0):
            self.Treeview.insert("", "end", values=(temps, a, b, c, d, e, f, g, h, k))



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