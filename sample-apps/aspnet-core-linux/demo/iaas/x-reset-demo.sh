#!/bin/bash
echo "Delete the IaaS docker hosts svr1 and svr2"
#az account set --subscription "Microsoft Azure Internal Consumption"
az vm delete -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIX -y
az network nic delete -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIXVMNic
az network public-ip delete -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIXPublicIP
az disk delete -g 'ossdemo-appdev-iaas' -n 'svr1-disk'

az vm delete -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIX -y
az network nic delete -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIXVMNic
az network public-ip delete -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIXPublicIP
az disk delete -g 'ossdemo-appdev-iaas' -n 'svr2-disk'

#remove docker swarm cluster -- We also need to do this on every node
echo "Leave swarm cluster on SVR 2"
#echo "$(sudo docker swarm init --advertise-addr=${masterip})"
echo "$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr2-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "sudo docker swarm leave -f")"
echo "-------------------------"
echo ""
echo "Leave swarm cluster on SVR 1"
#echo "$(sudo docker swarm init --advertise-addr=${masterip})"
echo "$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "sudo docker swarm leave -f")"
echo "-------------------------"
echo ""
echo "Leave swarm cluster on Jumpbox (if configured)"
#echo "$(sudo docker swarm init --advertise-addr=${masterip})"
echo "$(sudo docker swarm leave -f)"
echo "-------------------------"
echo ""

