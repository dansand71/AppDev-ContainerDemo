#!/bin/bash
read -p "This will distroy the container demo resource groups: ossdemo-appdev-acs, ossdemo-appdev-iaas, ossdemo-appdev-paas.  This process is not reversable.  Continue? [y/n]:"  continuescript
if [[ $continuescript == "y" ]];then

echo 'Use a particular subscription - you should modify this for your scenrio'
#az account set --subscription "Microsoft Azure Internal Consumption"

echo 'Delete ossdemo-appdev-acs resource group'
az group delete --name ossdemo-appdev-acs -y --no-wait

echo 'Delete ossdemo-appdev-iaas resource group'
az group delete --name ossdemo-appdev-iaas -y --no-wait

echo 'Delete ossdemo-appdev-paas resource group'
az group delete --name ossdemo-appdev-paas -y --no-wait
