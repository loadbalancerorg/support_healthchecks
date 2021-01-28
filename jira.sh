#!/bin/bash
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# CREATED BY: Matt Toner
# UPDATED BY: Neil Stone <support@loadbalancer.org>
# DATE: 2021-01-28
# Quick and dirty way the check jira status
# REQUIREMENTS: 'jq' from https://stedolan.github.io/jq/ installed in /usr/local/bin/

# Command Line Parameters
VIRTUAL_IP=${1}
VIRTUAL_PORT=${2}
REAL_IP=${3}
REAL_PORT=${4}

# Service check protocol
SPROT=https
# Jira check protocol
JPROT=https

# Default assume it fails
EXIT_CODE=1

# Exit now if not enough args
if [ $# -lt 3 ]; then
        # Exit state 4 if not enough args
        exit 4
fi

# Set real server port from $4 unless that's "0" or not present (inherited)
if [ "${4}" == "0" ] || [ -z "${4}" ]; then
    REAL_PORT="${2}"
else
    REAL_PORT="${4}"
fi

# Get the HTTP Reponse from the server check
# Response format will be a HTTP Response.
#               200 No Error
#               403 forbidden
#               500 Internal Error
#               503 unavailable
SERVICE=$(curl -m 3 -k -s -o /dev/null -w "%{http_code}" ${SPROT}://${REAL_IP}:${REAL_PORT}/status)
if [ "${SERVICE}" -eq "200" ]; then
        JIRA_STATE=$(curl -m 3 -k -s "${JPROT}://${REAL_IP}:${REAL_PORT}/status" | jq -r ".state")
        if [ "${JIRA_STATE}" == "RUNNING" ]; then
                # JIRA Service shows it's running
                EXIT_CODE="0"
        else
                # Jira status doesn't report 'RUNNING'
                EXIT_CODE="2"
        fi
else
        # 200 was not returned from initial curl request
        EXIT_CODE="3"
fi

# Exit the program with proper flag
exit ${EXIT_CODE}
