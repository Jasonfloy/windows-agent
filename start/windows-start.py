#!/usr/bin/env python
#encoding=utf-8
import os
import time
from Tkinter import *
import webbrowser

class HyperlinkManager:

    def __init__(self, text):

        self.text = text
        self.text.tag_config("hyper", foreground="blue", underline=1)
        self.text.tag_bind("hyper", "<Enter>", self._enter)
        self.text.tag_bind("hyper", "<Leave>", self._leave)
        self.text.tag_bind("hyper", "<Button-1>", self._click)
        self.reset()

    def reset(self):
        self.links = {}

    def add(self, action):
        # add an action to the manager.  returns tags to use in
        # associated text widget
        tag = "hyper-%d" % len(self.links)
        self.links[tag] = action
        return "hyper", tag

    def _enter(self, event):
        self.text.config(cursor="hand2")

    def _leave(self, event):
        self.text.config(cursor="")

    def _click(self, event):
        for tag in self.text.tag_names(CURRENT):
            if tag[:6] == "hyper-":
                self.links[tag]()
                return


root = Tk()
root.title("hold your hosts!")
root.geometry('460x80')
root.iconbitmap("windows-agent.ico")
text = Text(root)
text.pack()

hyperlink = HyperlinkManager(text)

def click():
    url = "http://highwe.net/hostList"
    webbrowser.open(url)



def main():
    #os.popen("hold-agent.exe -install") #��װ�������
    #os.popen('sc config AgentService start= AUTO')  #�����Զ�����
    #rt = os.popen('sc start AgentService') #��������
    #re = rt.read()
    #rt.close()
    if 0:
	text.insert(INSERT,'\n')
        text.insert(INSERT, "   �����ɹ�,���¼".decode('gbk'))
        text.insert(INSERT, "http://highwe.net/hostList", hyperlink.add(click))
        text.insert(INSERT, "�鿴������Ϣ!".decode('gbk'))
        mainloop()
    else:
	text.insert(INSERT,'\n')
        text.insert(INSERT, "��Ǹ����δ������,��¼".decode('gbk'))
        text.insert(INSERT, "http://highwe.net/hostList", hyperlink.add(click))
        text.insert(INSERT, "�鿴������Ϣ!".decode('gbk'))
        mainloop()
        #pass
    				
if __name__ == '__main__':
    main()
