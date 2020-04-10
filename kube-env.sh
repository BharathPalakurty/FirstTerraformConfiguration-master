#!/bin/bash
	echo " terraform apply starting....."
	terraform  apply 

	echo " creating -controller vms..........."
	./create-controller-vms

	echo " creating worker vms.........."
	./create-worker-node-vms-as

	echo " CA --certficates starting generation......" 
	./CA.sh
	
	echo " config setup start for kuberenetes ........."
	./config.sh

	echo " ENCRYPTION config setup start for kuberenetes ........."
	./encrypt.sh

#For both the steps run set-controller0-etcboot.sh set-controller1-etcboot.sh
#  etcd cluster ==  need to repeat for each CONTROLLER-- etc-boot-controller0.sh  etc-boot-controller1.sh
#control plan == need to repear for each controller kube-control-plane-0.sh


