#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

projectdir="/source/AppDev-ContainerDemo/sample-apps/drupal"


echo -e "${BOLD}Checking to see if we need to download the sample app...${RESET}"
mkdir -p /source/AppDev-ContainerDemo/sample-apps/drupal/tmp
if [ "$(ls -A ${projectdir}/tmp)" ]; then
     echo ".files already downloaded, no action needed."
else
    echo ".source directory is empty.  cloning from github."
    cd ${projectdir}/tmp
    git clone https://github.com/dansand71/sampleApp-drupal .

    mv ${projectdir}/tmp ${projectdir}
    rm tmp
    #Set Scripts as executable & ensure everything is writeable
    echo ".set any scripts as executable"
    sudo chmod +x /source/AppDev-ContainerDemo/environment/set-scripts-executable.sh
    /source/AppDev-ContainerDemo/environment/set-scripts-executable.sh

    #Reset DEMO Values
    echo ".reset demo values"
    /source/AppDev-ContainerDemo/environment/reset-demo-template-values.sh
fi
