#!/bin/bash -x
# Medstar Healthcheck v1.0 by Andrei Grigoras
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/bin:$PATH

#Variables passed by ldirectord.
# $1 = VIP Address
# $2 = VIP Port
# $3 = Real Server IP
# $4 = Real Server Port

# Command Line Parameters
VIRTUAL_IP=$1
VIRTUAL_PORT=$2
REAL_IP=$3
#REAL_IP=192.168.1.211
#REAL_PORT=$4

# TMEOUT is how long to allow for each check, 2-3 is a sensible sort of number unless the proxy is expected to be very slow.
TMEOUT=2

# Set directory for log
OUTPUTDIR=/var/log/faillog

# check directory for log
if	[ ! -d $OUTPUTDIR ];
then
	mkdir $OUTPUTDIR
fi

#Define VIP names as created
VIP1="VIP_Name"
VIP2="VIP_Name-2"
VIP3="VIP_Name-3"

#Define RIP names as created, the names are the same under each VIP
RIP1="RIP_Name"
RIP2="RIP_Name-1"
RIP3="RIP_Name-2"

#Success String
#SUCCESS="\"status\": \"OK\""
SUCCESS="Apache"

#Default failure Exit Code
EXIT_CODE=0

#Program starts

#STATUS=$(curl --connect-timeout $TMEOUT -k -i https://$REAL_IP:2525/rialto/status)
STATUS1=$(curl --connect-timeout "$TMEOUT" -k -i http://$REAL_IP:80)

# Functions
function check-realserver {
	if	echo "$STATUS1" | grep -q -i "$SUCCESS";
	then 
		EXIT_CODE1=0
		echo $EXIT_CODE1 > $OUTPUTDIR/rip1.log
	else
		EXIT_CODE1=1
		echo $EXIT_CODE1 > $OUTPUTDIR/rip1.log
	fi
}

function check-statuscode {
	if	[ $(cat $OUTPUTDIR/rip1.log) -eq 0 ]
	then	
		EXIT_CODE2=0
	        lbcli --action online --vip $VIP1 --rip $RIP1
	        lbcli --action online --vip $VIP2 --rip $RIP1
	        lbcli --action online --vip $VIP3 --rip $RIP1
	else 
		if	[ $(cat $OUTPUTDIR/rip1.log) -eq 1 ]
		then
		EXIT_CODE2=1
		echo "$(date '+%Y-%m-%d_%H:%M:%S') $3"  >> $OUTPUTDIR/faillog.log
		lbcli --action halt --vip $VIP1 --rip $RIP1
		lbcli --action halt --vip $VIP2 --rip $RIP1
		lbcli --action halt --vip $VIP3 --rip $RIP1
		fi
	fi
}

function check-exitcode {
	TOTAL_EXIT_CODE=$(( $EXIT_CODE1 + $EXIT_CODE2 ))
	if [ "$TOTAL_EXIT_CODE" -eq 0 ]; then
		EXIT_CODE="0"
	else
		EXIT_CODE=$TOTAL_EXIT_CODE
		exit $EXIT_CODE
	fi
}
check-realserver
check-statuscode
check-exitcode
