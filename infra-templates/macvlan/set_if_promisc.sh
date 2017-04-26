#!/bin/bash

set -ex

MASTER_IF=${MASTER_IF:-eth0}

TEST_IF=$(ip addr show $MASTER_IF | grep 'inet\b' | awk '{print $2}')
if [ ! -z $TEST_IF ]; then
    exit 0
fi

ip link set dev ${MASTER_IF} promisc on

