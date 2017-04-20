#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

projectdir="/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux"

#echo -e "${BOLD}Create resources needed for demo's...${RESET}"
#read -p "$(echo -e -n "${INPUT}Create new resources for demo? [Y/n]:"${RESET})" continuescript
#if [[ ${continuescript,,} != "n" ]]; then
    #Add logic for creating resources here
    #~/bin/az documentdb create --name VALUEOF-UNIQUE-SERVER-PREFIX-documentdb --resource-group ossdemo-appdev-paas --kind MongoDB
#fi

echo -e "${BOLD}Checking to see if we need to download the sample app...${RESET}"
mkdir -p /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/src
if [ "$(ls -A ${projectdir}/src)" ]; then
     echo ".files already downloaded, no action needed."
else
    echo ".source directory is empty.  cloning from github."
    cd ${projectdir}/src
    git clone https://github.com/dansand71/sampleApp-aspnetcore .

    #Set Scripts as executable & ensure everything is writeable
    echo ".set any scripts as executable"
    sudo chmod +x /source/AppDev-ContainerDemo/environment/set-scripts-executable.sh
    /source/AppDev-ContainerDemo/environment/set-scripts-executable.sh

    #Reset DEMO Values
    echo ".reset demo values"
    /source/AppDev-ContainerDemo/environment/reset-demo-template-values.sh
fi
