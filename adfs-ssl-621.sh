#!/bin/bash
host=$3   
port=$4
openssl s_client -connect $3:$4 </dev/null #2>&1
