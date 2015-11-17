#!/bin/bash
#Cascading Health Check V1.0 by Aaron West.

#Variables passed by ldirectord.
# $1 = VIP Address
# $2 = VIP Port
# $3 = Real Server IP
# $4 = Real Server Port

#Script Variables for check port.
CHECK_IP="$3"           #Should be $3 so it picks up the IP from ldirectord.
CHECK_PORT="$4"         #Should be $4 so it picks up the Port from ldirectord, otherwise for a port list use a space seperated format "80 443 8080".
CHECK_TIMEOUT="3"	#Port time out value.

#Script Variables for check http.
HTTP_IP="$3"            #Domain, IP or ldirectiord variable.
HTTP_PAGE="index.html"  #Page to look for when doing a check-http.
HTTP_PORT="80"          #Port for check-http, can be $4.

#Defaults
HTTP_CHECK="0"          #Set defaults.
PORT_CHECK="0"          #Set defaults.

#Functions.
function check-port {
        for i in $CHECK_PORT; do nc -w $CHECK_TIMEOUT -zvn $CHECK_IP $i &> /dev/null {}; done
        if [ "$?" -eq "0" ]; then
                PORT_CHECK="0"
        else
            	PORT_CHECK="4"
        fi
}
function check-http {
        links -dump "${HTTP_IP}:${HTTP_PORT}/${HTTP_PAGE}" &> /dev/null
        if [ "$?" -eq "0" ]; then
                HTTP_CHECK="0"
        else
            	HTTP_CHECK="2"
        fi
}
function finish {
        TOTAL=$(( $PORT_CHECK + $HTTP_CHECK ))
        if [ "$TOTAL" -eq "0" ]; then
                EXIT_CODE="0"
        else
            	EXIT_CODE=$TOTAL;
                exit $EXIT_CODE
fi
}

#Execute the following functions
#Options:
#check-port - Performs a connect check.
#check-http - Performs HTTP check.
#finish - Final function that decides pass or fail.
check-http
check-port
finish

