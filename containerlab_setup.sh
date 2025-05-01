#!/bin/bash

CURR_DIR=$(pwd)

sudo docker run --rm -it --privileged --network host -v /var/run/docker.sock:/var/run/docker.sock -v /var/run/netns:/var/run/netns -v /etc/hosts:/etc/hosts -v /var/lib/docker/containers:/var/lib/docker/containers --pid="host" -v $CURR_DIR:$CURR_DIR -w $CURR_DIR ghcr.io/srl-labs/clab bash
