#!/bin/bash
RESET="\e[0m"
BOLD="\e[4m"
INPUT="\e[7m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"
echo -e "${BOLD}mWelcome to the OSS Demo for Simple app dev Containers.  This demo will configure:${RESET}"
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
sudo chmod +x /source/AppDev-ContainerDemo/envrionment/set-scripts-executable.sh
/source/AppDev-ContainerDemo/envrionment/set-scripts-executable.sh
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

#Necessary for demos to build and restore .NET application

sudo chmod +x /source/AppDev-ContainerDemo/2-SetupDemo.sh

echo -e "${BOLD}Checking for an existing settings file.  If found we will pull values from /source/appdev-demo-EnvironmentTemplateValues${RESET}"
if [ -f /source/appdev-demo-EnvironmentTemplateValues ];
  then
    echo ".Existing settings file found.  NOT copying a new version from /source/AppDev-ContainerDemo/vm-assets"
  else
    #Do we have an existing variables file?
    if [ -f /source/DemoEnvironmentValues ];
    then
      echo ".No existing settings file found.  Trying to pull values from original jumpbox setup to prepopulate"
      source /source/DemoEnvironmentValue
      echo ".Pre-populating with original demo settings"
      echo "...JUMPBOX_SERVER_NAME="$JUMPBOX_SERVER_NAME
      echo "...DEMO_ADMIN_USER_NAME="$DEMO_ADMIN_USER_NAME
      echo "...DEMO_SERVER_PREFIX="$DEMO_SERVER_PREFIX
      echo "...DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
      echo "...DEMO_STORAGE_PREFIX="$DEMO_STORAGE_PREFIX
    fi
    #No Settings file found - can we copy in a couple defaults to make the editing process easier?
    echo ".Copying the template file for your additional edits - /source/appdev-demo-EnvironmentTemplateValues"
    sudo cp /source/AppDev-ContainerDemo/vm-assets/DemoEnvironmentTemplateValues /source/appdev-demo-EnvironmentTemplateValues
    sudo sudo sed -i -e "s@DEMO_UNIQUE_SERVER_PREFIX=""@DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX"@g" /source/appdev-demo-EnvironmentTemplateValues
    sudo sudo sed -i -e "s@DEMO_STORAGE_ACCOUNT=""@DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT"@g" /source/appdev-demo-EnvironmentTemplateValues
    sudo sudo sed -i -e "s@DEMO_ADMIN_USER_NAME=""@DEMO_STORAGE_ACCOUNT="$DEMO_ADMIN_USER_NAME"@g" /source/appdev-demo-EnvironmentTemplateValues
    echo ".Please update /source/appdev-demo-EnvironmentTemplateValues with your values and re-run this script."
      sudo gedit /source/appdev-demo-EnvironmentTemplateValues
    exit
fi

source /source/appdev-demo-EnvironmentTemplateValues
echo -e "${BOLD}Current Template file values:${RESET}"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX
echo "      DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
echo "      DEMO_ADMIN_USER_NAME="$DEMO_ADMIN_USER_NAME
echo "      DEMO_REGISTRY_SERVER-NAME="$DEMO_REGISTRY_SERVER_NAME
echo "      DEMO_REGISTRY_USER_NAME="$DEMO_REGISTRY_USER_NAME
echo "      DEMO_REGISTRY_PASSWORD="$DEMO_REGISTRY_PASSWORD
echo "      DEMO_OMS_WORKSPACE="$DEMO_OMS_WORKSPACE
echo "      DEMO_OMS_PRIMARYKEY="$DEMO_OMS_PRIMARYKEY
echo "      DEMO_APPLICATION_INSIGHTS_KEY="$DEMO_APPLICATION_INSIGHTS_KEY
echo ""

echo -e "${BOLD}Template Edit${RESET}"
read -p "Would you like to edit the template file now? [y/N]:" changefile
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