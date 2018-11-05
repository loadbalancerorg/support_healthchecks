#!/bin/bash

#############################################################
#
# SYN scan healthcheck
#
# (c) Loadbalancer.org 2018
#
# 2018-11-05 - Initial write - Neil Stone <support@loadbalancer.org>
#
#############################################################

TIMEOUT=2

### Shouldn't need to edit below here

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

if [ $# -lt 3 ]; then
    echo "Not enough args"
    exit 2
fi

### Error checking done...

VIP=${1}
VPT=${2}
RIP=${3}


if [ "${4}" == "0" ] || [ -z "${4}" ]; then
    RPT="${2}"
else
    RPT="${4}"
fi


timeout ${TIMEOUT} nmap -sS -p ${RPT} ${RIP} 2>&1 | grep -q 'open'

