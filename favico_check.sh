#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

## VMWARE UAG Health Check
## I B Graham  - info@loadbalancer.org
## v1.0 - Initial release

#Script Variables for check port.
CHECK_IP="$3"            # $3 is variable asigned an IP
CHECK_PORT="$4"         # $4 is variable asigned a Port
CHECK_TIMEOUT="5"            # Port time out value.

# Health check the favico.ico file looking for a response of "HTTP/1.1 200 OK", can manually be called ./favico.ico 0 0 <RIP> <RIP_PORT>

curl -m 5 -s -k -I https://$CHECK_IP:$CHECK_PORT/favicon.ico | head -1 | grep "HTTP/1.1 200 OK"
       


