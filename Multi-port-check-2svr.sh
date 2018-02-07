#!/bin/bash
#Declare Path
PATH=/var/lib/loadbalancer.org/check/:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/

# Health check script to check the port(s) on the Real server passed in args from the LB
# and if success to then lookup the database IP from a file and execute checks on its port(s)

#Variables passed by ldirectord.
# $1 = VIP Address
# $2 = VIP Port
# $3 = Real Server IP
# $4 = Real Server Port

# Return code 0, ok, 1 Real server issue, 2 'backend' server issue, 99 error in backendchecks file (new RIP server not added perhaps?)

#Script Variables for check port.
BACKENDS=/var/lib/loadbalancer.org/check/Multi-port-check-2svr.cf #Contains space delimited file of VIP ip, RIP ip, DB ip and port numbers, one set per line
CHECK_VIP="$1"
CHECK_IP="$3"           #Should be $3 so it picks up the IP from ldirectord.
CHECK_PORT="$4"         #Should be $4 so it picks up the Port from ldirectord, otherwise for a port list use a space seperated format "80 443 8080".
CHECK_TIMEOUT="3"       #Port time out value.

if  [[ ! $CHECK_VIP =~ ^([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$ ]] && [[ ! $CHECK_VIP =~ ^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$ ]]; then
        firewallmark=/etc/rc.d/auto_fwmarks/fwmark-$CHECK_VIP
	FWM=$CHECK_VIP
	if [ -f $firewallmark ]; then 	
		CHECK_VIP=$(cat $firewallmark | grep D | /usr/bin/head -1 | cut -d' ' -f9)
		CHECK_PORT=$(cat $firewallmark | grep D | cut -d' ' -f11)
		CHECK_PORT=$(echo $CHECK_PORT | tr -d '\n')
	else
		# echo "not autofirewallmark"
		# We do not know how to deal with manual firewall marks yet. 
		# We will exit 1 here to force a healthcheck failure
		exit 1;
	fi
fi
#echo "VIP $CHECK_VIP Port $CHECK_PORT RIP $CHECK_IP" >>/tmp/z
for i in $CHECK_PORT; do
	#echo "checking $CHECK_IP port $i"
        nc -w $CHECK_TIMEOUT -zvn $CHECK_IP $i &>/dev/null
	ec=$?
	if [ $ec -ne "0" ]; then
                exit 1
        fi
done
read vip rip CHECK_IP CHECK_PORT < <( grep "$CHECK_VIP $CHECK_IP" $BACKENDS ) || exit 99
#echo "VIP $CHECK_VIP Port $CHECK_PORT DB $CHECK_IP" >>/tmp/z
#echo "checking IP "$CHECK_IP" for port(s) "$CHECK_PORT
for i in $CHECK_PORT; do
	#echo "checking $CHECK_IP port $i"
        nc -w $CHECK_TIMEOUT -zvn $CHECK_IP $i &>/dev/null
	ec=$?
	if [ $ec -ne "0" ]; then
                exit 2
        fi
done
exit 0

