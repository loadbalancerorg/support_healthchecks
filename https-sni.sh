#!/bin/bash
PATH=/usr/bin:/bin

#############################################################
#
# Script to check https RIPs using SNI
#
# (c) Loadbalancer.org 2019
#
# 2018-08-24 - Initial write - Neil Stone <support@loadbalancer.org>
# 2018-08-30 - Added PATH statement - Neil Stone <support@loadbalancer.org>
# 2018-09-04 - Changed 'if' statement to handle L4/L7 shenanigans - Neil Stone <support@loadbalancer.org>
# 2019-01-14 - Added some comments to make the script more user understandable - Neil Stone <support@loadbalancer.org>
#
#############################################################

# CHECK_HOST is the FQDN for the hostname (not protocol)
CHECK_HOST="https.site.address"

# CHECK_PATH is the path to GETto run the test against
CHECK_PATH="LoadbalancerStatus.php"

# CHECK_STRING is the string to detect for upon success, should be returned early in the result of the GET
CHECK_STRING="Success"


### Nothing below here should need changing...

# Reminder as to what the variables that are pulled in are.
#VIP=${1} # VIP IP address
#VPT=${2} # VIP port
#RIP=${3} # Real server IP address
#RPT=${4} # Real server port

# If less than 3 args, exit
if [ ${#} -lt 3 ]; then
    exit 12
fi

# Script Variables for check port.
CHECK_IP="${3}"

# HAProxy always passes 4 vars, where check port is 0 unless defined in config.
# ldirectord passes 3 or 4 depending on RIP port definition.

if [ "${4}" == "0" ] || [ -z "${4}" ]; then
    CHECK_PORT="${2}"
else
    CHECK_PORT="${4}"
fi

# Build curl options variable
CURL_OPTS="--resolve ${CHECK_HOST}:${CHECK_PORT}:${CHECK_IP}"

# Run curl with appropriate options
curl ${CURL_OPTS} -H 'Host: '${CHECK_HOST}'' -m 2 -k https://${CHECK_HOST}/${CHECK_PATH} 2>/dev/null | grep -q "${CHECK_STRING}"

EXIT_STATE=${?}

exit ${EXIT_STATE}
