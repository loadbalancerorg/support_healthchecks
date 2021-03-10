#!/bin/bash
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

#
# SMTP Health check
# CREATED BY: Neil Stone <support@loadbalancer.org>
# DATE: 2021-03-10
# Use cURL to check for basic SMTP function
#

# Set these as required
SENDER=sender@mydomain.com
MAILTO=recipient@mydomain.com

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

curl --silent --max-time 3 --insecure smtp://${RIP}:${RPT}  --mail-from "${SENDER}" --mail-rcpt "${MAILTO}" > /dev/null
EC=${?}

exit ${EC}
