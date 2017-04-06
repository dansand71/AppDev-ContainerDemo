#!/bin/bash
RESET="\e[0m"
BOLD="\e[4m"
INPUT="\e[7m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"
echo -e "${BOLD}Welcome to the OSS Demo for Simple app dev Containers.  This demo will configure:${RESET}"
echo "    - Resource group - ossdemo-appdev-iaas"
echo "    - Resource group - ossdemo-appdev-acs"
echo "    - Resource group - ossdemo-appdev-paas"
echo ""
echo "It will also modify scripts for the demo and download the GIT repository and create:"
echo "     - Servers in ossdemo-appdev-iaas"
echo "     - Kubernetes cluster in ossdemo-appdev-acs"
echo "     - Azure app service in ossdemo-appdev-paas"
echo ""
echo "Installation & Configuration will require SU rights but pleae run this script as an ADMIN."
echo ""
echo "This particular demo script will create a settings file that can be reused and install pre-requisites."
echo ".Setting scripts as executable"
sudo chmod +x /source/AppDev-ContainerDemo/environment/set-scripts-executable.sh
/source/AppDev-ContainerDemo/environment/set-scripts-executable.sh
echo ".Resetting rights on /source"
sudo chmod -R 777 /source

echo -e "${BOLD}Checking to ensure AZ CLI is installed.  If not we will install and ask for defaults.${RESET}"
#Check to see if Azure is installed if not do it.  You will have to rerun the setup script after...
if [ -f ~/bin/az ]
  then
    echo ".AZ Client installed. Skipping install.."
  else
    echo ".Need to install Azure Tools."
    curl -L https://aka.ms/InstallAzureCli | bash
fi

#update AZ Components
echo ".Checking for AZ CLI updates and adding in ACR components"
az component update --add acr
az component update

#Install JQ so we can parse JSON results in BASH
sudo yum install -q jq -y


echo ".Logging in to Azure"
#Checking to see if we are logged into Azure
echo "..Checking if we are logged in to Azure."
#We need to redirect the output streams to stdout
azstatus=`~/bin/az group list 2>&1` 
if [[ $azstatus =~ "Please run 'az login' to setup account." ]]; then
        echo "...We need to login to azure.."
        ~/bin/az login
    else
        echo "...Logged in."
fi

read -p "$(echo -e -n "${INPUT}..Change default subscription? [y/N]${RESET}")" changesubscription
if [[ $changesubscription =~ "y" ]];then
        read -p "...New Subscription Name:" newsubscription
        ~/bin/az account set --subscription "$newsubscription"
    else
        echo "..Using default existing subscription."
fi

#Necessary for demos to build and restore .NET application

sudo chmod +x /source/AppDev-ContainerDemo/2-SetupDemo.sh

echo "---------------------------------------------"
echo -e "\e[7mResource Group Creation\e[0m"
read -p "Create resource groups required for demo? [Y/n]:"  continuescript
if [[ $continuescript != "n" ]];then
    #BUILD RESOURCE GROUPS
    echo ""
    echo "BUILDING RESOURCE GROUPS"
    echo "--------------------------------------------"
    echo 'create ossdemo-appdev-iaas, ossdemo-appdev-acs, ossdemo-appdev-paas resource groups'
    ~/bin/az group create --name ossdemo-appdev-iaas --location eastus
    ~/bin/az group create --name ossdemo-appdev-acs --location eastus
    ~/bin/az group create --name ossdemo-appdev-paas --location eastus
fi

echo -e "${BOLD}Checking for an existing settings file.  If found we will pull values from /source/appdev-demo-EnvironmentTemplateValues${RESET}"
if [ -f /source/appdev-demo-EnvironmentTemplateValues ];
  then
    echo ".Existing settings file found.  NOT copying a new version from /source/AppDev-ContainerDemo/vm-assets"
  else
    #Do we have an existing variables file?
    if [ -f /source/DemoEnvironmentValues ];
    then
      echo ".No existing settings file found.  Trying to pull values from original jumpbox setup to prepopulate"
      source /source/DemoEnvironmentValues
      echo ".Pre-populating with original demo settings"
      echo "...JUMPBOX_SERVER_NAME="$JUMPBOX_SERVER_NAME
      echo "...DEMO_ADMIN_USER="$DEMO_ADMIN_USER
      echo "...DEMO_SERVER_PREFIX="$DEMO_SERVER_PREFIX
      echo "...DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
      echo "...DEMO_STORAGE_PREFIX="$DEMO_STORAGE_PREFIX
    fi
    #No Settings file found - can we copy in a couple defaults to make the editing process easier?
    echo ".Copying the template file for your additional edits - /source/appdev-demo-EnvironmentTemplateValues"
    sudo cp /source/AppDev-ContainerDemo/vm-assets/DemoEnvironmentTemplateValues /source/appdev-demo-EnvironmentTemplateValues
    sudo sudo sed -i -e "s@DEMO_UNIQUE_SERVER_PREFIX=@DEMO_UNIQUE_SERVER_PREFIX=${DEMO_SERVER_PREFIX}@g" /source/appdev-demo-EnvironmentTemplateValues
    sudo sudo sed -i -e "s@DEMO_STORAGE_ACCOUNT=@DEMO_STORAGE_ACCOUNT={$DEMO_STORAGE_ACCOUNT}@g" /source/appdev-demo-EnvironmentTemplateValues
    sudo sudo sed -i -e "s@DEMO_ADMIN_USER=@DEMO_ADMIN_USER=${DEMO_ADMIN_USER}@g" /source/appdev-demo-EnvironmentTemplateValues
    # echo ".Please update /source/appdev-demo-EnvironmentTemplateValues with your values and re-run this script."
    #   sudo gedit /source/appdev-demo-EnvironmentTemplateValues
    # exit
fi

source /source/appdev-demo-EnvironmentTemplateValues
if [[ $DEMO_REGISTRY_SERVER_NAME = "" ]]; then
  # Create a new DEMO_REGISTRY_PASSWORD
  echo "---------------------------------------------"
  echo -e "\e[7mAzure Registry\e[0m"
  read -p "Create azure registry needed for the demo? [Y/n]:"  continuescript
  if [[ $continuescript != "n" ]];then
      #Create Azure Registry
      /source/AppDev-ContainerDemo/environment/create-az-registry.sh
      
      #Get the new server
      REGISTRYSERVER=dansand@DANSAND-BOOK:~$ az resource show -g ossdemo-utility -n 'dansanddemoregistry' --resource-type Microsoft.ContainerRegistry/registries --output json | jq '.properties.loginServer'
      
      #Set the login server in the config file
      sudo sed -i -e "s@DEMO_REGISTRY_SERVER_NAME=@DEMO_REGISTRY_SERVER_NAME=$REGISTRYSERVER@g" /source/appdev-demo-EnvironmentTemplateValues

  fi
fi

if [[ $DEMO_APPLICATION_INSIGHTS_ASPNETLINUX_KEY = "" ]] ; then
  # Create new app insights 
  echo "---------------------------------------------"
  echo -e "\e[7mApp Insights\e[0m"
  read -p "Create app insights resources needed for the demo? [Y/n]:"  continuescript
  if [[ $continuescript != "n" ]];then
      #Create App Insights
      ~/bin/az group deployment create --resource-group ossdemo-utility --name InitialDeployment \
        --template-file /source/AppDev-ContainerDemo/environment/ossdemo-utility-appinsights.json
      
      #Get the new instrumentation keys
      ASPNETCOREKEY=az resource show -g ossdemo-utility -n 'app Insight aspnet-core-linux' --resource-type microsoft.insights/components --output json | jq '.properties.InstrumentationKey'
      ECONTAINERSHOPKEY=az resource show -g ossdemo-utility -n 'app Insight eShopOnContainer' --resource-type microsoft.insights/components --output json | jq '.properties.InstrumentationKey'
      
      #Set these values in the config file by default
      sudo sed -i -e "s@DEMO_APPLICATION_INSIGHTS_ASPNETLINUX_KEY=@DEMO_APPLICATION_INSIGHTS_ASPNETLINUX_KEY=$ASPNETCOREKEY@g" /source/appdev-demo-EnvironmentTemplateValues
      sudo sed -i -e "s@DEMO_APPLICATION_INSIGHTS_ESHOPONCONTAINERS_KEY=@DEMO_APPLICATION_INSIGHTS_ESHOPONCONTAINERS_KEY=$ECONTAINERSHOPKEY@g" /source/appdev-demo-EnvironmentTemplateValues
  fi
fi

source /source/appdev-demo-EnvironmentTemplateValues
echo -e "${BOLD}Current Template file values:${RESET}"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX
echo "      DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
echo "      DEMO_ADMIN_USER="$DEMO_ADMIN_USER
echo "      DEMO_REGISTRY_SERVER-NAME="$DEMO_REGISTRY_SERVER_NAME
echo "      DEMO_REGISTRY_USER_NAME="$DEMO_REGISTRY_USER_NAME
echo "      DEMO_REGISTRY_PASSWORD="$DEMO_REGISTRY_PASSWORD
echo "      DEMO_OMS_WORKSPACE="$DEMO_OMS_WORKSPACE
echo "      DEMO_OMS_PRIMARYKEY="$DEMO_OMS_PRIMARYKEY
echo "      DEMO_APPLICATION_INSIGHTS_ASPNETLINUX_KEY="$DEMO_APPLICATION_INSIGHTS_ASPNETLINUX_KEY
echo "      DEMO_APPLICATION_INSIGHTS_ESHOPONCONTAINERS_KEY="$DEMO_APPLICATION_INSIGHTS_ESHOPONCONTAINERS_KEY
echo ""

echo -e "${BOLD}Template Edit${RESET}"
read -p "Would you like to edit the template file now to add in the Registry Username and Password values? [y/N]:" changefile
if [[ $changefile =~ "y" ]];then
    sudo gedit /source/appdev-demo-EnvironmentTemplateValues   
fi
#Check once more that we have rights on all files that were copied or moved...
sudo chmod -R 777 /source

echo -e "${BOLD}Environment Setup${RESET}"
read -p "Would you like to setup the Demo? [y/N]:" continueDemo
if [[ $continueDemo =~ "y" ]];then
    /source/AppDev-ContainerDemo/2-setup-demo.sh
fi

echo "    Script complete.  Please run ./2-SetupDemo.sh to prepare the demo"