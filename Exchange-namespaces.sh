#!/bin/bash 
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

## MS Exchange Health Check
## D J Saunders - info@loadbalancer.org
## v1.0 - Initial release.
## v1.1 - Neil Stone - Add in support for namespaces.

#Script Variables for check port.
CHECK_IP="$3"            # $3 is variable asigned an IP 
CHECK_PORT="$4"         # $4 is variable asigned a Port
CHECK_TIMEOUT="5"            # Port time out value.

#Defaults
HTTP_CHECK="0"          #Set default

#Check domain...
DOMAIN="mydomain.com"
#Hostnames to check
OWA_HOST="owa.${DOMAIN}"
EWS_HOST="ews.${DOMAIN}"
OAB_HOST="oab.${DOMAIN}"
MAPI_HOST="mapi.${DOMAIN}"
RPC_HOST="rpc.${DOMAIN}"
ACTIVESYNC_HOST="activesync.${DOMAIN}"
AUTODISCOVER_HOST="autodiscover.${DOMAIN}"

## Outlook Web App (OWA)
        curl -s -k -I -H "Host: ${OWA_HOST}" https://$CHECK_IP:443/OWA/HealthCheck.htm | grep 200 >>/dev/null
        if [ "$?" -eq "0" ]; then
                OWA_HTTP_CHECK="0"
        else
                OWA_HTTP_CHECK="2"
        fi

## Exchange Web Services (EWS)
        curl -s -k -I  -H "Host: ${EWS_HOST}" https://$CHECK_IP:443/EWS/HealthCheck.htm | grep 200 >>/dev/null
        if [ "$?" -eq "0" ]; then
                EWS_HTTP_CHECK="0"
        else
                EWS_HTTP_CHECK="3"
        fi

## Offline Address Book (OAB)
        curl -s -k -I  -H "Host: ${OAB_HOST}" https://$CHECK_IP:443/OAB/HealthCheck.htm | grep 200 >>/dev/null
        if [ "$?" -eq "0" ]; then
                OAB_HTTP_CHECK="0"
        else
                OAB_HTTP_CHECK="7"
        fi

## MAPI
        curl -s -k -I  -H "Host: ${MAPI_HOST}" https://$CHECK_IP:443/mapi/HealthCheck.htm | grep 200 >>/dev/null
        if [ "$?" -eq "0" ]; then
                MAPI_HTTP_CHECK="0"
        else
                MAPI_HTTP_CHECK="11"
        fi

## RPC
        curl -s -k -I  -H "Host: ${RPC_HOST}" https://$CHECK_IP:443/RPC/HealthCheck.htm | grep 200  >>/dev/null
        if [ "$?" -eq "0" ]; then
                RPC_HTTP_CHECK="0"
        else
                RPC_HTTP_CHECK="15"
        fi

## ActiveSync
        curl -s -k -I  -H "Host: ${ACTIVESYNC_HOST}" https://$CHECK_IP:443/ActiveSync/HealthCheck.htm | grep 200 >>/dev/null
        if [ "$?" -eq "0" ]; then
                ACTIVESYNC_HTTP_CHECK="0"
        else
                ACTIVESYNC_HTTP_CHECK="24"
        fi

## AutoDiscover
        curl -s -k -I  -H "Host: ${AUTODISCOVER_HOST}" https://$CHECK_IP:443/Autodiscover/Autodiscover.xml | grep 200 >>/dev/null
        if [ "$?" -eq "0" ]; then
                AUTODISCOVER_HTTP_CHECK="0"
        else
                AUTODISCOVER_HTTP_CHECK="36"
        fi


## Exit code validation
    TOTAL=$(( $OWA_HTTP_CHECK + $EWS_HTTP_CHECK + $OAB_HTTP_CHECK + $MAPI_HTTP_CHECK + $RPC_HTTP_CHECK + $ACTIVESYNC_HTTP_CHECK + $AUTODISCOVER_HTTP_CHECK ))
    if [ "$TOTAL" -eq "0" ]
    then
            EXIT_CODE="0"
    else
            EXIT_CODE=$TOTAL
            exit $EXIT_CODE
        fi
