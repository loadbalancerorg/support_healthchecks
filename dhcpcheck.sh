#!/bin/bash

#DHCPCHECK script v1
#Created by IGraham 23/08/18

## This script uses the nmap command tied with the in built dhcp-discover script to probe the real server port and determine the status of the DHCP Server. It does this by matching the DHCP message by either being a DHCPOFFER or DHCPACK as a positive health check. If any other status is returned or the port fails to connect then the health check will fail.

#Variables passed by ldirectord.
# $1 = VIP Address
# $2 = VIP Port
# $3 = Real Server IP
# $4 = Real Server Port


#Script Variables for check port.
CHECK_IP="$3"           #Should be $3 so it picks up the IP from ldirectord.
CHECK_PORT="$2"         #Should be $4 so it picks up the Port from ldirectord, otherwise for a port list use a space seperated format "80 443 8080"
TIMEOUT="4"	            #Port time out value.
CHECK_VALUE1="DHCPOFFER"
CHECK_VALUE2="DHCPACK"

NMAP_OUTPUT=$(/usr/bin/nmap -sU -p $CHECK_PORT --host-timeout $TIMEOUT --script=dhcp-discover $CHECK_IP  | egrep "$CHECK_VALUE1|$CHECK_VALUE2" | awk {'print $5'})
if [[ "$NMAP_OUTPUT" == $CHECK_VALUE1 ]] || [[ "$NMAP_OUTPUT" == $CHECK_VALUE2 ]]
then
    	EXIT_CODE=0
else
    	EXIT_CODE=1
fi

exit $EXIT_CODE



