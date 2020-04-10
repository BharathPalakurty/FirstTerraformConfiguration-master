WORKER="worker-0"
PUBLIC_IP_ADDRESS=$(az network public-ip show -g kubernetes \
  -n ${WORKER}-pip --query "ipAddress" -otsv)

ssh kuberoot@${PUBLIC_IP_ADDRESS}
