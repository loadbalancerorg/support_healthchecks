#!/bin/bash
#Cascading Health Check V1.1 by Andrei Grigoras.

#Variables passed by ldirectord.
# $1 = VIP Address
# $2 = VIP Port
# $3 = Real Server IP
# $4 = Real Server Port

#Script Variables for check port.
CHECK_IP="$3"            # $3 is variable asigned an IP from ldirectord.
#CHECK_PORT="$4"         # $4 is variable asigned a Port from ldirectord, otherwise for a port list use a space seperated format "80 443 8080".
CHECK_PORT="9080 9443"
CHECK_TIMEOUT="5"	     # Port time out value.

#Script Variables for check-http.
HTTP_IP="$3"              		# Domain, IP or ldirectord variable.
HTTP_PAGE="lbadmin"  	  		# Page to look for when doing a check-http.
HTTP_PORT="9080"          		# Port for check-http, can be $4.
HTTP_USER="loadbalancer"  		# User for logon when doing check-http.
HTTP_PASSWORD="loadbalancer" 	# Password for HTTP_USER when doing check-http.

#Defaults
HTTP_CHECK="0"          #Set default
PORT_CHECK="0"          #Set defaults

#Functions

# check-port function - Checks if port(s) are up on the Real Server.
function check-port {
        for i in $CHECK_PORT; do echo $i; nc -w $CHECK_TIMEOUT -zvn $CHECK_IP $i &> /dev/null {}; done
        if [ "$?" -eq "0" ]; then
            PORT_CHECK="0"
        else
            PORT_CHECK="5"
        fi
}

# check-http function - Logins the user with the variables mentioned above.
function check-http {
		curl -u ${HTTP_USER}:${HTTP_PASSWORD} ${HTTP_IP}:${HTTP_PORT}/${HTTP_PAGE}
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

