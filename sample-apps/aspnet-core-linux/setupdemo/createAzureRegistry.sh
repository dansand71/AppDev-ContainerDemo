echo "Be sure to login to Azure prior to running this script."
#az account set --subscription "Microsoft Azure Internal Consumption"

#CREATE AZURE REGISTRY
echo ""
echo "Create Azure Registry - this will be used to host the docker containers.  Working on a bug where this isnt allowed inside my VS Enterprise Subscription."
echo "--------------------------------------------"
echo " navigate to the Utility resource group.  Name of the new registry - VALUEOF-REGISTRY-USER-NAME"
az component update --add acr
az acr create -n VALUEOF-REGISTRY-USER-NAME -g ossdemo-utility -l eastus \
        --storage-account-name VALUEOF-UNIQUE-STORAGE-ACCOUNT \
        --admin-enabled true
