#!/usr/bin/env python
#encoding=utf-8
import os
import time

def main():
    os.popen('sc stop AgentService') #停止服务
    time.sleep(3)
    os.popen("hold-agent.exe -remove") #卸载服务
    time.sleep(2)
    rt = os.popen('tasklist /svc /fi "imagename eq hold-agent.exe"') #判断进程是否还存在
    re = rt.read()
    rt.close()
    if re: #如果进程依然存在，杀掉进程
        pid = int(re.split()[7])
        #print pid
        cmd = "taskkill /pid %d /f " % pid
        os.popen(cmd)
        os.popen('del /q hold-agent.exe') #删掉旧版本服务程序
    else:
        pass
	
if __name__ == '__main__':
    main()
