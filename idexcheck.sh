#!/bin/bash

VHOST=${1}
VPORT=${2}
RHOST=${3}
RPORT=2948

nc -z ${RHOST} ${RPORT}

STATUS=${?}

if [ ${STATUS} -eq 0 ];
then
	exit 0
else
	exit 42
fi
