#!/usr/bin/env python

import re
import time
import subprocess

lifeline = re.compile(r"(\d) packets received")
report = ("No response", "Partial Response", "Alive")

print(time.ctime())

for host in range(1,254):   
    ip = "192.168.1."+str(host)   
    pingaling = subprocess.Popen(["ping","-q", "-c 2", "-r",  ip], shell=False, stdin=subprocess.PIPE, stdout=subprocess.PIPE)   
    print("Ping", ip, end=': ')
    while 1:      
        pingaling.stdout.flush()      
        line = pingaling.stdout.readline()      
        if not line: break
        igot = re.findall(lifeline, line.decode('UTF-8'))  
        if igot:           
            print(report[int(igot[0])])

print(time.ctime())