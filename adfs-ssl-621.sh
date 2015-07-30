#!/bin/bash
host=$3   
port=$4
echo GET /adfs/ls/idpinitiatedsignon.aspx\r\n | openssl s_client -connect $3:$4


