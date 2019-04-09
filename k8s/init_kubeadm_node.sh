#!/bin/bash

USER=$1
MASTER=$2
NODE=$3
LABEL=$4

rsh -l $USER $MASTER 'sudo kubeadm token create --print-join-command' > tmp.xln
sed -i '1s;^;sudo ;' tmp.xln
rsh -l $USER $NODE "$(cat tmp.xln)"
#rsh -l $USER $MASTER "kubectl label node "$NODE" "($LABEL)""