#!/bin/bash
set -x

#VIP=${1}
#VPT=${2}
#RIP=${3}
#RPT=${4}

CHECK_HOST="gdpr.marshalls.co.uk"
CHECK_PATH="LoadbalancerStatus/LoadBalancer-Status-Page.aspx"
CHECK_STRING="Loadbalancer Status Page"

### Nothing below here should need changing...


if [ ${#} -lt 3 ]; then
    exit 12
fi

# Script Variables for check port.
CHECK_IP="${3}"

if [ "${4}" -ne "" ]; then
    CHECK_PORT="${4}"
else
    CHECK_PORT="${2}"
fi

CURL_OPTS="--resolve ${CHECK_HOST}:${CHECK_PORT}:${CHECK_IP}"

# curl --resolve gdpr.marshalls.co.uk:443:10.101.147.15 -m 2 -H 'Host: gdpr.marshalls.co.uk' -i -k https://gdpr.marshalls.co.uk/LoadbalancerStatus/LoadBalancer-Status-Page.aspx

curl ${CURL_OPTS} -H 'Host: ${CHECK_HOST}' -m 2 -i -k https://${CHECK_HOST}/${CHECK_PATH} | grep -q ${CHECK_STRING}

${?}
