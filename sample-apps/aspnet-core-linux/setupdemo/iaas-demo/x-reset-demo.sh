#!/bin/bash
echo "Delete the service and deployment which will cleanup the pods and external IP's'"
#az account set --subscription "Microsoft Azure Internal Consumption"
az vm delete -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIX -y
az network nic delete -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIXVMNic
az network public-ip delete -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIXPublicIP
az disk delete -g 'ossdemo-appdev-iaas' -n 'svr1-disk'

az vm delete -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIX -y
az network nic delete -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIXVMNic
az network public-ip delete -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIXPublicIP
az disk delete -g 'ossdemo-appdev-iaas' -n 'svr2-disk'

