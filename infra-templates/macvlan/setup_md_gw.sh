#/bin/bash

set -ex

MASTER=${MASTER:-eth0}
MD_GW_IP=${MD_GW_IP:-192.168.22.1/24}
SUBNET=${SUBNET:-192.168.22.0/24}
MTU=${MTU:-1500}
MD_GW_IF="rancher-md-gw"

TEST_EXIST=$(ip addr show ${MD_GW_IF} | grep 'inet\b' | awk '{print $2}')
if [ ! -z $TEST_EXIST  ]; then
        exit 0
    fi

    ip link add ${MD_GW_IF} link ${MASTER} type macvlan mode bridge
    ip addr add ${MD_GW_IP} brd + dev ${MD_GW_IF}
    ip link set dev ${MD_GW_IF} mtu ${MTU}
    ip link set dev ${MD_GW_IF} up


    iptables -t nat -D POSTROUTING -s ${SUBNET} ! -o ${MD_GW_IF} -j MASQUERADE || true
    iptables -t nat -A POSTROUTING -s ${SUBNET} ! -o ${MD_GW_IF} -j MASQUERADE || true
    #modprobe ebtable_nat
    #ebtables -t nat -D POSTROUTING -p arp --arp-opcode 1 --arp-ip-dst ${MD_GW_IP} -o ${MASTER} -j DROP || true

