#!/usr/bin/env python
#encoding=utf-8
import os
import time

def main():
    os.popen('sc stop AgentService') #ֹͣ����
    time.sleep(3)
    os.popen("hold-agent.exe -remove") #ж�ط���
    time.sleep(2)
    rt = os.popen('tasklist /svc /fi "imagename eq hold-agent.exe"') #�жϽ����Ƿ񻹴���
    re = rt.read()
    rt.close()
    if re: #���������Ȼ���ڣ�ɱ������
        pid = int(re.split()[7])
        #print pid
        cmd = "taskkill /pid %d /f " % pid
        os.popen(cmd)
        os.popen('del /q hold-agent.exe') #ɾ���ɰ汾�������
    else:
        pass
	
if __name__ == '__main__':
    main()
