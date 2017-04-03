#!/bin/bash

echo "Creating Kubernetes cluster for Demo #2."
echo "Be sure to login to Azure prior to running this script."
#az account set --subscription "Microsoft Azure Internal Consumption"

##TO-DO - TURN on Diagnostics as well as POWER-OFF TIMES
#az vm boot-diagnostics enable -n centos-utility -g utility

#CREATE KUBERNETES CLUSTER
echo "Create network, VNET"
echo "----------------------------------"
echo "Create VNET - az network vnet create -n 'ossdemo-appdev-acs-vnet' -g ossdemo-appdev-acs"
        az network vnet create -n 'ossdemo-appdev-acs-vnet' -g ossdemo-appdev-acs
echo " Create Subnet: 10.2.0.0/24"
echo "    running - az network vnet subnet create -g ossdemo-appdev-acs --vnet-name ossdemo-appdev-acs-vnet -n ossdemo-appdev-acs-subnet --address-prefix 10.2.0.0/24 --network-security-group NSG-ossdemo-appdev-acs"
        az network vnet subnet create -g ossdemo-appdev-acs --vnet-name ossdemo-appdev-acs-vnet -n ossdemo-appdev-acs-subnet --address-prefix 10.2.0.0/24 --network-security-group NSG-ossdemo-appdev-acs 
echo "----------------------------------"

echo ""
echo 'Create Kubernetes cluster for K8S Demo'
echo "--------------------------------------------"

echo "CREATE K8S Cluster"
az acs create --orchestrator-type=kubernetes --resource-group=ossdemo-appdev-acs \
        --name=k8s-VALUEOF-UNIQUE-SERVER-PREFIX --dns-prefix=k8s-VALUEOF-UNIQUE-SERVER-PREFIX \
        --agent-vm-size Standard_DS1_v2 \
        --admin-username gbbossdemo --master-count 1 \
        --ssh-key-value="REPLACE-SSH-KEY"

echo "Attempting to install the kubernetes client within the Azure CLI tools.  This can fail due to user rights.  Try to resolve and re-run: sudo az acs kubernetes install-cli"
az acs kubernetes install-cli --install-location ~/bin/kubectl

echo "Login to the K8S environment"
#az account set --subscription "Microsoft Azure Internal Consumption"
az acs kubernetes get-credentials \
        --resource-group ossdemo-appdev-acs \
        --name k8s-VALUEOF-UNIQUE-SERVER-PREFIX

echo "create secret to login to the private registry"
kubectl create secret docker-registry ossdemoregistrykey \
        --docker-server=VALUEOF-REGISTRY-SERVER-NAME \
        --docker-username=VALUEOF-REGISTRY-USER-NAME \
        --docker-password=VALUEOF-REGISTRY-PASSWORD \
        --docker-email=GBBOSS@microsoft.com
