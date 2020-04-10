#!/bin/bash
CONTROLLER="controller-0"

PUBLIC_IP_ADDRESS=$(az network public-ip show -g kubernetes \
  -n ${CONTROLLER}-pip --query "ipAddress" -otsv)
echo "The Public IP address is " $PUBLIC_IP_ADDRESS
ssh kuberoot@${PUBLIC_IP_ADDRESS}




