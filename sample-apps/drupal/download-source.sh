#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

projectdir="/source/AppDev-ContainerDemo/sample-apps/drupal"
tempdir="~/drupal"
sourceproject="https://github.com/dansand71/sampleApp-drupal"

echo -e "${BOLD}Cloning project.${RESET}"
rm -rf ${tempdir} ${projectdir} ; mkdir -p ${tempdir} ${projectdir}

cd ${tempdir}
git clone ${sourceproject} .

cp -r ${tempdir}. ${projectdir}
rm -rf ${tempdir}
    
cd ${projectdir}
#Set Scripts as executable & ensure everything is writeable
echo ".set any scripts as executable"
/source/AppDev-ContainerDemo/environment/set-scripts-executable.sh

#Reset DEMO Values
echo ".reset demo values"
/source/AppDev-ContainerDemo/environment/reset-demo-template-values.sh

echo ".done"