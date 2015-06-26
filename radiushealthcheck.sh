#!/bin/bash
username=steve
password=testing
nashost=$2
nasport=1812
nassecret=testing123
nasname=localhost
radtest $username $password $nashost:$nasport 0 $nassecret 0 $nasname >/dev/null
echo $?
