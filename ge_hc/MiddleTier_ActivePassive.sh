#!/bin/bash

################################################################################
#             Middle Tier check automatically halting real servers             #
#                                   v1.1.0                                     #
#                              Loadbalancer.org                                #
################################################################################
#                                                                              #
#  |----------|-------------------------------------------------------------|  #
#  | Version  | Changes                                                     |  #
#  |----------|-------------------------------------------------------------|  #
#  | 1.0.0    | Initial release                                             |  #
#  |----------|-------------------------------------------------------------|  #
#  | 1.1.0    | Added check_port variable to the script for upcoming update |  #
#  |          | to CPACS which will disable port 80 and enable port 443 for |  #
#  |          | checks.                                                     |  #
#  |----------|-------------------------------------------------------------|  #
#  | 1.1.1    | Added the vip_label to the log output required to permit    |  #
#  |          | multiple instances of the health check to be configured on  |  #
#  |          | a single appliance.                                         |  #
#  |----------|-------------------------------------------------------------|  #
#                                                                              #
################################################################################

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/

################################################################################
###                              Configuration                               ###
################################################################################

vip_label="DB_MT"                 # Virtual Service Label
check_port=80                     # The TCP port to check on the Real Servers
primary_label="IMS1"              # IMS1 - Real Server Label
primary_ip="10.10.10.111"         # IMS1 - Real Server IP Address
secondary_label="IMS2"            # IMS2 - Real Server Label
secondary_ip="10.10.10.112"       # IMS2 - Real Server IP Address

################################################################################
###                            DO NOT EDIT BELOW!                            ###
################################################################################

# Variables passed by ldirectord
# $1 = VIP Address
# $2 = VIP Port
# $3 = Real Server IP
# $4 = Real Server Port

rs="${3}"
counter=0

soft_fail(){
    echo "fail" > /var/log/"${my_label}"_"${vip_label}"_prev
}

fail(){
    soft_fail
    exit 1
}

panic(){
    lbcli_cmd "halt" "${secondary_label}" 
}

soft_pass(){
    echo "pass" > /var/log/"${my_label}"_"${vip_label}"_prev
}

pass(){
    soft_pass
    exit 0
}

is_online(){
    ipvsadm -Ln | grep -q "${1}"
}

lbcli_cmd(){
    lbcli "${1}" --vip "${vip_label}" --rip "${2}" &>/dev/null &
}

halt(){
    soft_check "fail" && lbcli_cmd "halt" "${my_label}" ||
     fail
    
}

online(){
    soft_check "pass" && lbcli_cmd "online" "${my_label}" ||
     pass
}

soft_check(){
    grep -q "${1}" /var/log/"${my_label}"_"${vip_label}"_prev
}

which_rs(){
    case "$1" in
    "${primary_ip}")
        my_ip="${primary_ip}"
        my_label="${primary_label}"
        other_ip="${secondary_ip}"
        ;;

    "${secondary_ip}")
        my_ip="${secondary_ip}"
        my_label="${secondary_label}"
        other_ip="${primary_ip}"
        ;;
    esac
}

check(){
    nc -zvn "${1}" $check_port &>/dev/null
}

am_i_active(){
    grep -q "active" /var/log/nodestatus_local
}

action(){
case "$1" in
  0 | 1 | 4 | 8 | 9 | 12)
    fail
    ;;

  5 | 13)
    halt
    ;;

  3)
    online
    ;;

  2 | 6 | 7 | 10 | 11 | 14)
    pass
    ;;

  15)
    panic
    ;;
esac
}

main() {
    which_rs "${1}"
    am_i_active && counter=$((counter + 1))
    check "${my_ip}" && counter=$((counter + 2))
    is_online "${my_ip}" && counter=$((counter + 4))
    is_online "${other_ip}" && counter=$((counter + 8))
    echo "$(date) ${my_label} - ${my_ip} COUNTER ${counter}" >> /var/log/"${vip_label}"
    action "${counter}"
}

main "${rs}"
