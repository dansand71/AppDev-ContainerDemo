echo "Be sure to login to Azure prior to running this script."
#az account set --subscription "Microsoft Azure Internal Consumption"

##TO-DO - TURN on Diagnostics as well as POWER-OFF TIMES
#az vm boot-diagnostics enable -n centos-utility -g utility

#CREATE KUBERNETES CLUSTER
echo ""
echo 'Create Kubernetes cluster for K8S Demo'
echo "--------------------------------------------"

echo "CREATE K8S Cluster"
az acs create --orchestrator-type=kubernetes --resource-group=ossdemo-appdev-acs \
        --name=k8s-VALUEOF-UNIQUE-SERVER-PREFIX --dns-prefix=k8s-VALUEOF-UNIQUE-SERVER-PREFIX \
        --agent-vm-size Standard_DS1_v2
        --admin-username GBBOSSDemo --master-count 1 \
        --ssh-key-value="REPLACE-SSH-KEY"

echo "Attempting to install the kubernetes client within the Azure CLI tools.  This can fail.  Try to resolve and re-run: sudo az acs kubernetes install-cli"
az acs kubernetes install-cli --install-location ~/bin/kubectl