#!/bin/bash
set -x

PATH=/sbin:/bin:/usr/sbin:/usr/bin

#$1 = VIP Address
#$2 = VIP Port
#$3 = Real Server IP
#$4 = Real Server Port

if [ ${#} -lt 3 ]; then
    exit 12
fi

#Script Variables for check port.
CHECK_IP="${3}"

if [ ! -z "${4}" ]; then
    CHECK_PORT="${4}"
else
    CHECK_PORT="${2}"
fi

### Set the absolute path here...
CHECK_PATH="lbbdirmgr/index.html" # Path to fetch


STATUS=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' -k https://${CHECK_IP}:${CHECK_PORT}/${CHECK_PATH})
#STATUS=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' http://${CHECK_IP}:${CHECK_PORT}/${CHECK_PATH})

if [ ${STATUS} -ne 401 ] ; then
# If not 401
    exit 1
else
# If 401
	exit 0
fi
