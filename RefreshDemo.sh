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

git clone https://github.com/dansand71/AppDev-ContainerDemo 
sudo chmod +x /source/AppDev-ContainerDemo/1-create-settings-file.sh
sudo chmod +x /source/AppDev-ContainerDemo/2-setup-demo.sh

#Set Scripts as executable & ensure everything is writeable
sudo chmod +x /source/AppDev-ContainerDemo/environment/set-scripts-executable.sh
/source/AppDev-ContainerDemo/environment/set-scripts-executable.sh

#Reset DEMO Values
/source/AppDev-ContainerDemo/environment/reset-demo-template-values.sh

echo "Download source for the samples."
sourcedir="/source/AppDev-ContainerDemo"
sampleList=(
    "${sourcedir}/aspnet-core-linux"
    "${sourcedir}/drupal"
    "${sourcedir}/eShopOnContainers"
    "${sourcedir}/nodejs-todo"
)
for sample in "${sampleList[@]}"
do
    echo -e "${BOLD}Working on $sample ${RESET}"
    pushd $project
    ./download-source.sh
    popd
done

echo ""
echo "Complete"
echo ""
