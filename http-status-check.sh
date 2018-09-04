#!/bin/bash
#set -x
PATH=/sbin:/bin:/usr/sbin:/usr/bin

########################################################################
#
# Script to check for a defined http status and pass if it's presented.
#
# Neil Stone - support@loadbalancer.org
#
# v 1.0 initial commit
#
########################################################################

DESIRED_STATUS=401

#$1 = VIP Address
#$2 = VIP Port
#$3 = Real Server IP
#$4 = Real Server Port

if [ ${#} -lt 3 ]; then
    exit 12
fi

#Script Variables for check port.
CHECK_IP="${3}"

if [ "${4}" == "0" ] || [ -z "${4}" ]; then
    CHECK_PORT="${2}"
else
    CHECK_PORT="${4}"
fi

### Set the absolute path here...
CHECK_PATH="authpage/index.html" # Path to fetch


# first for https, second for http.
# might also want to add host header as per:   -H 'Host: myhostname.mydomain.com' in the curl command(s)
#
STATUS=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' -k https://${CHECK_IP}:${CHECK_PORT}/${CHECK_PATH})
#STATUS=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' http://${CHECK_IP}:${CHECK_PORT}/${CHECK_PATH})

if [ ${STATUS} -ne ${DESIRED_STATUS} ] ; then
# No match = exit with error
    exit 1
else
# Match = exit clean
	exit 0
fi
