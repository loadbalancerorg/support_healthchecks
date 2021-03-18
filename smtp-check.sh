#!/bin/bash
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

#
# SMTP Health check
# CREATED BY: Neil Stone <support@loadbalancer.org>
# DATE: 2021-03-10
# Use netcat to check for basic SMTP function
#

### Nothing below here should need adjustment ###

VIP=${1}
VPT=${2}
RIP=${3}

# Set real server port from ${4} unless that's "0" or not present (inherited)
if [ "${4}" == "0" ] || [ -z "${4}" ]; then
    RPT="${2}"
else
    RPT="${4}"
fi

echo QUIT | nc ${RIP} ${RPT} | grep -q -e "^220"

EC=${?}

exit ${EC}
