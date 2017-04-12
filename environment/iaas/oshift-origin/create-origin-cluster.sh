#!/bin/bash
RESET="\e[0m"
BOLD="\e[4m"
INPUT="\e[7m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"
echo -e "${BOLD}Create openshift origin cluster.  This demo will configure:${RESET}"
echo "    - Resource group - ossdemo-appdev-oshift"
echo ""
echo "It will also modify scripts for the demo and download the GIT repository and create:"
echo "     - 3 Servers in ossdemo-appdev-oshift"
echo "     - Azure Vault"
echo ""
echo "Installation & Configuration will require SU rights"
echo ""


echo "---------------------------------------------"
echo -e "${BOLD}Resource Group Creation${RESET}"
read -p "Create resource groups, keyvault and secrets required for demo? [Y/n]:"  continuescript
if [[ ${continuescript,,} != "n" ]];then
    #BUILD RESOURCE GROUPS
    echo ""
    echo "BUILDING RESOURCE GROUP"
    echo "--------------------------------------------"
    echo 'create ossdemo-appdev-oshift resource group'
    ~/bin/az group create --name ossdemo-appdev-oshift --location eastus
    echo 'create openshift key vault'
    ~/bin/az keyvault create -n oshiftvault -g ossdemo-appdev-oshift -l eastus --enabled-for-template-deployment true
    #Sleep 30 seconds while Vault gets setup
    sleep 30
    echo 'create openshift secret ~/.ssh/id_rsa private key'
    ~/bin/az keyvault secret set --vault-name oshiftvault -n oshiftsecret --file ~/.ssh/id_rsa
fi
echo "---------------------------------------------"
echo -e "${BOLD}Openshift Template deployment${RESET}"
echo -e "This template is from https://github.com/Azure/azure-quickstart-templates/tree/master/openshift-origin-rhel"
echo ""
echo ".setting openshift defaults for JSON template"
### Admin cluster password
while true
do
  read -s -p "$(echo -e -n "${INPUT}.New Admin Password for Cluster:${RESET}")" clusterPassword
  echo ""
  read -s -p "$(echo -e -n "${INPUT}.Re-enter to verify:${RESET}")" clusterPassword2
  
  if [ $clusterPassword = $clusterPassword2 ]
  then
     break 2
  else
     echo -e ".${RED}Passwords do not match.  Please retry. ${RESET}"
  fi
done
sed -i -e "s@REPLACE-ADMIN-PASSWORD@$clusterPassword@g" /source/AppDev-ContainerDemo/environment/iaas/oshift-origin/oshift-origin-template.json
echo ".reading in existing RSA PUBLIC key from ~/.ssh/id_rsa.pub"
sshpubkey=$(< ~/.ssh/id_rsa.pub)
#this could error out if "|" is present in the key
sed -i -e "s|REPLACE-RSA-PUB-KEY|$sshpubkey|g" /source/AppDev-ContainerDemo/environment/iaas/oshift-origin/oshift-origin-template.json

read -p "$(echo -e -n "${INPUT}Deployments can take up to 30 minutes and requires up to 8 CPU in the default configuration.${RESET} \e[5m[press any key to continue]:${RESET}")"
~/bin/az group deployment create --resource-group ossdemo-appdev-oshift --name InitialDeployment \
        --template-file /source/AppDev-ContainerDemo/environment/iaas/oshift-origin/oshift-origin-template.json

echo "complete..."
echo "Please access the web console @ https://VALUEOF-UNIQUE-SERVER-PREFIX-ossdemo-oshift-master.eastus.cloudapp.azure.com:8443/console"