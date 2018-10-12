#!/bin/bash

#############################################################
#
# SSH login health check
#
# (c) Loadbalancer.org 2018
#
# 2018-10-11 - Initial write - Neil Stone <support@loadbalancer.org>
#
#############################################################

PWFILE=/root/ldappw.txt
SSHUSER=root
TIMEOUT=2

### Shouldn't need to edit below here

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

if [ ! -x /usr/bin/sshpass ]; then
    echo "sshpass required: yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/Packages/s/sshpass-1.06-1.el6.x86_64.rpm"
    exit 1
fi

if [ $# -lt 3 ]; then
    echo "Not enough args"
    exit 2
fi

if [ ! -f ${PWFILE} ]; then
    echo "Cannot read ${PWFILE}"
    exit 4
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


timeout ${TIMEOUT} sshpass -f${PWFILE} ssh -o StrictHostKeyChecking=no -o NumberOfPasswordPrompts=1 -l ${SSHUSER} -p ${RPT} ${3} echo > /dev/null 2> /dev/null

