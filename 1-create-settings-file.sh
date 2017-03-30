#!/bin/bash
echo "Welcome to the OSS Demo for Simple app dev Containers.  This demo will configure:"
echo "    - Resource group - ossdemo-appdev-iaas"
echo "    - Resource group - ossdemo-appdev-acs"
echo "    - Resource group - ossdemo-appdev-paas"
echo ""
echo "It will also modify scripts for the demo and download the GIT repository and create:"
echo "     - Servers in ossdemo-appdev-iaas"
echo "     - Kubernetes cluster in ossdemo-appdev-acs"
echo "     - Azure app service in ossdemo-appdev-paas"
echo ""
echo "Installation & Configuration will require SU rights but pleae run this script as GBBOSSDemo."
echo ""
echo "This particular demo script will create a settings file that can be reused and install pre-requisites."
echo ""
echo ""
echo "Installing AZ command line tools if they are missing."

#Check to see if Azure is installed if not do it.  You will have to rerun the setup script after...
if [ -f ~/bin/az ]
  then
    echo "    AZ Client installed. Skipping install.."
  else
    echo "    Need to install Azure Tools."
    curl -L https://aka.ms/InstallAzureCli | bash
fi

#update AZ Components
az component update --add acr
az component update

#Necessary for demos to build and restore .NET application
sudo chmod -R 777 /source
sudo chmod +x /source/AppDev-ContainerDemo/2-SetupDemo.sh

if [ -f /source/appdev-demo-EnvironmentTemplateValues ];
  then
    echo "    Existing settings file found.  Not copying the version from /source/AppDev-ContainerDemo/vm-assets"
  else
    echo "    Copying the template file for your edits - /source/appdev-demo-EnvironmentTemplateValues"
    sudo cp /source/AppDev-ContainerDemo/vm-assets/DemoEnvironmentTemplateValues /source/appdev-demo-EnvironmentTemplateValues
    echo "    Please update /source/appdev-demo-EnvironmentTemplateValues and re-run this script."
    exit
fi

source /source/appdev-demo-EnvironmentTemplateValues
echo ""
echo "Current Template Values:"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX
echo "      DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
echo "      DEMO_REGISTRY_SERVER-NAME="$DEMO_REGISTRY_SERVER_NAME
echo "      DEMO_REGISTRY_USER_NAME="$DEMO_REGISTRY_USER_NAME
echo "      DEMO_REGISTRY_PASSWORD="$DEMO_REGISTRY_PASSWORD
echo "      DEMO_OMS_WORKSPACE="$DEMO_OMS_WORKSPACE
echo "      DEMO_OMS_PRIMARYKEY="$DEMO_OMS_PRIMARYKEY
echo "      DEMO_APPLICATION_INSIGHTS_KEY="$DEMO_APPLICATION_INSIGHTS_KEY
echo ""

read -p "    Would you like to edit this file now? [y/n]:" changefile
if [[ $changefile =~ "y" ]];then
    sudo gedit /source/appdev-demo-EnvironmentTemplateValues   
fi
echo "    Script complete.  Please run ./2-SetupDemo.sh to prepare the demo"