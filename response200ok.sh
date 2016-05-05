#!/bin/bash
#Variables passed by ldirectord.
# $1 = VIP Address
# $2 = VIP Port
# $3 = Real Server IP
# $4 = Real Server Port
page="/"
status=$(curl -sL -w "%{http_code}\\n" "http://$3:$4$page" -o /dev/null)
if [[ "$status" -eq "200" ]]
then 
	exit 0
else 
	exit 1
fi
