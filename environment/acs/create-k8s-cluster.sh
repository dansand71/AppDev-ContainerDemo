#!/bin/bash
echo "Creating Kubernetes cluster."
#CREATE KUBERNETES CLUSTER
~/bin/az acs create --orchestrator-type=kubernetes --resource-group=ossdemo-appdev-acs \
        --name=k8s-VALUEOF-UNIQUE-SERVER-PREFIX --dns-prefix=k8s-VALUEOF-UNIQUE-SERVER-PREFIX \
        --agent-vm-size Standard_DS1_v2 \
        --admin-username VALUEOF-DEMO-ADMIN-USER-NAME --master-count 1 \
        --ssh-key-value="REPLACE-SSH-KEY"

echo "Attempting to install the kubernetes client within the Azure CLI tools.  This can fail due to user rights.  Try to resolve and re-run: sudo az acs kubernetes install-cli"
~/bin/az acs kubernetes install-cli --install-location ~/bin/kubectl

echo "Login to the K8S environment"
#az account set --subscription "Microsoft Azure Internal Consumption"
~/bin/az acs kubernetes get-credentials \
        --resource-group ossdemo-appdev-acs \
        --name k8s-VALUEOF-UNIQUE-SERVER-PREFIX

echo "create secret to login to the private registry"
~/bin/kubectl create secret docker-registry ossdemoregistrykey \
        --docker-server=VALUEOF-REGISTRY-SERVER-NAME \
        --docker-username=VALUEOF-REGISTRY-USER-NAME \
        --docker-password=VALUEOF-REGISTRY-PASSWORD \
        --docker-email=GBBOSS@microsoft.com

echo "create storage account for persistent volumes"
~/bin/az storage account create --location eastus \
        --name ossdemok8sVALUEOF-UNIQUE-SERVER-PREFIX \
        --resource-group ossdemo-appdev-acs \
        --sku Premium_LRS
                          