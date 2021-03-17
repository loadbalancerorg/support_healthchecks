#!/bin/bash

# need to install samba with yum -y install samba
# initially samba does not need touching hopefully
# need remote registry
# https://www.howtogeek.com/109655/how-to-remotely-shut-down-or-restart-windows-pcs/


start_remote_service () {
	net rpc -I $HOST -U ${USERNAME}%${PASSWORD} service start $nameOfService 
}


stop_remote_service () {
	net rpc -I $HOST -U ${USERNAME}%${PASSWORD} service stop $nameOfService
}





nameOfService=Spooler
USERNAME=smalley
PASSWORD=c749qbrc
HOST=192.168.122.140

start_remote_service
stop_remote_service


6	0.000559	192.168.0.254	192.168.0.254	MySQL	132	Login Request user=tfoerste


tcppacket=1

exit tcppacket

#!/usr/bin/env python2
from scapy.all import *
sport = 3377
dport = 2222
src = "192.168.40.2"
dst = "192.168.40.135"
ether = Ether(type=0x800, dst="00:0c:29:60:57:04", src="00:0c:29:78:b0:ff")
ip = IP(src=src, dst=dst)
SYN = TCP(sport=sport, dport=dport, flags='S', seq=1000)
xsyn = ether / ip / SYN / "Some Data"
packet = xsyn.build()
print(repr(packet))