#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

########
#
# udp-port-check.sh - Health check script to probe a remote UDP port
#
# Written by Neil Stone - Support@Loadbalancer.org
# v1.0 - 2021-02-19
#
#######

TIMEOUT=2

### Nothing below here should need altering

# Exit now if not enough args
if [ $# -lt 3 ]; then
        # Exit state 4 if not enough args
        exit 4
fi

VIP=${1}
VPT=${2}
RIP=${3}

# Set real server port from ${4} unless that's "0" or not present (inherited)
if [ "${4}" == "0" ] || [ -z "${4}" ]; then
    RPT="${2}"
else
    RPT="${4}"
fi

# Perform the connect to port attempt
nc -w ${TIMEOUT} -uz ${RIP} ${RPT} >/dev/null
EC=${?}

exit ${EC}
