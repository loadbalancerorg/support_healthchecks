#!/bin/bash
PATH=/usr/bin:/bin

#############################################################
#
# Script to check https RIPs using SNI
#
# (c) Loadbalancer.org 2018
#
# 2018-08-24 - Initial write - Neil Stone <support@loadbalancer.org>
# 2018-08-30 - Added PATH statement - Neil Stone <support@loadbalancer.org>
#
#############################################################


#VIP=${1}
#VPT=${2}
#RIP=${3}
#RPT=${4}

CHECK_HOST="https.site.address"
CHECK_PATH="LoadbalancerStatus.php"
CHECK_STRING="Success"


### Nothing below here should need changing...


if [ ${#} -lt 3 ]; then
    exit 12
fi

# Script Variables for check port.
CHECK_IP="${3}"

if [ -z "${4}" ]; then
    CHECK_PORT="${2}"
else
    CHECK_PORT="${4}"
fi

CURL_OPTS="--resolve ${CHECK_HOST}:${CHECK_PORT}:${CHECK_IP}"

curl ${CURL_OPTS} -H 'Host: '${CHECK_HOST}'' -m 2 -k https://${CHECK_HOST}/${CHECK_PATH} 2>/dev/null | grep -q "${CHECK_STRING}"

EXIT_STATE=${?}

exit ${EXIT_STATE}
