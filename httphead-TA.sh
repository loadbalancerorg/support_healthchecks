#!/bin/bash
#Variables
REAL_IP=$3
REAL_PORT=$4
REQUEST="tc/tc/Main.jsp?message="
RESPONSE="200 OK"

# Get the Page/File
curl -Is http://$REAL_IP:$REAL_PORT/$REQUEST | egrep -q "$RESPONSE"
if [ "$?" -eq "0" ]; then
EXIT_CODE="0"
else
EXIT_CODE="1"
fi

exit $EXIT_CODE
