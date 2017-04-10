#!/bin/bash
echo "This script will re-clone the Github repository and re-apply environment template values to he source directories."
echo ""
echo ""

source /source/appdev-demo-EnvironmentTemplateValues
echo ""
echo "Current Template Values:"
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
echo "The remainder of this script deletes the existing /source/AppDev-ContainerDemo directory, reclones and resets script executables."
read -p "Press any key to continue or CTRL-C to exit... " startscript
echo ""

echo "    Remove existing demo environment ./AppDev-ContainerDemo" 
sudo rm -rf /source/AppDev-ContainerDemo
echo "    Reclone github repository https://github.com/dansand71/AppDev-ContainerDemo"

cd /source
#Necessary for demos to build and restore .NET application
sudo chmod -R 777 /source

sudo git clone https://github.com/dansand71/AppDev-ContainerDemo 
sudo chmod +x /source/AppDev-ContainerDemo/1-create-settings-file.sh
sudo chmod +x /source/AppDev-ContainerDemo/2-setup-demo.sh
cp /source/AppDev-ContainerDemo/RefreshDemo.sh /source/refresh-appdev-container-demo.sh
sudo chmod +x /source/refresh-appdev-container-demo.sh




#Set Scripts as executable & ensure everything is writeable
echo ".setting scripts as executables"
sudo chmod +x /source/AppDev-ContainerDemo/environment/set-scripts-executable.sh
/source/AppDev-ContainerDemo/environment/set-scripts-executable.sh

#Reset DEMO Values
/source/AppDev-ContainerDemo/environment/reset-demo-template-values.sh

echo ""
echo "Complete"
echo ""
