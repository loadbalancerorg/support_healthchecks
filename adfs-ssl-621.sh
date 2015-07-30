#!/bin/bash
host=$3
port=$2
echo GET /adfs/ls/idpinitiatedsignon.aspx\r\n | openssl s_client -connect $host:$port

