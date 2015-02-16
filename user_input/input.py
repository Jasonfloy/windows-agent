#encoding=utf-8
import win32ui
import win32con
import json
from pywin.mfc import dialog

def DlgTemplate(title):
        style = win32con.DS_MODALFRAME | win32con.WS_POPUP | win32con.WS_VISIBLE | win32con.WS_CAPTION | win32con.WS_SYSMENU | win32con.DS_SETFONT
        cs = win32con.WS_CHILD | win32con.WS_VISIBLE

        # Window frame and title
        dlg = [ [title, (0, 0, 284, 40), style, None, (10, "MS Sans Serif")], ] #10是输入框的像素(大小)

        # ID label and text box
        dlg.append([130, "User_Key:", -1, (15, 15, 69, 9), cs | win32con.SS_LEFT])#(7, 9, 69, 9)User Key标签的坐标
        s = cs | win32con.WS_TABSTOP | win32con.WS_BORDER 
        dlg.append(['EDIT', None, win32ui.IDC_EDIT1, (53, 13, 138, 12), s]) #(50, 7, 100, 12)User Key输入框的坐标，前2个控制上下，后两个控制大小

        # OK/Cancel Buttons
        s = cs | win32con.WS_TABSTOP 
        dlg.append([128, "OK", win32con.IDOK, (231, 11, 35, 15), s | win32con.BS_DEFPUSHBUTTON])#(124, 5, 50, 14)OK按钮的坐标,前2个控制上下
        return dlg

class VerfiyDlg(dialog.Dialog):
        def __init__(self, title):
                dialog.Dialog.__init__(self, DlgTemplate(title) )
                self.AddDDX(win32ui.IDC_EDIT1,'userkey')

def GetVerfiy(title='请输入您的密钥',userkey=''):
        d = VerfiyDlg(title)
        d['userkey'] = userkey
        if d.DoModal() != win32con.IDOK:
            return (None, None)
        else:
            if (d['userkey'] == ''):
                GetVerfiy(title='输入错误，请重新输入吧！',userkey='')
            else:
                with open('user.conf','w') as f:
                    input_data = dict(user_key=(d['userkey']))
                    f.write(json.dumps(input_data))

if __name__ == "__main__":
        userkey = GetVerfiy()
        #print dict(userkey=userkey)