#!/usr/bin/python2
import socket
import sys
rip = sys.argv[3]
port = int(sys.argv[2])
# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.settimeout(1)
message = 'HEALTHCHECK'
try:
    sent = sock.sendto(message, (rip, port))
    data, server = sock.recvfrom(4096)
    if data:
        sys.exit(0)
    else:
        sys.exit(1)
finally:
    sock.close()

