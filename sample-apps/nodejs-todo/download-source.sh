#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

projectdir="/source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src"
tempdir="$HOME/nodejs-todo"
sourceproject="https://github.com/dansand71/nodejs-todo"

echo -e "${BOLD}Cloning project.${RESET}"
rm -rf ${tempdir} 
rm -rf ${projectdir} 
mkdir -p ${tempdir} 
mkdir -p ${projectdir}

cd ${tempdir}
git clone ${sourceproject} .

cp -r ${tempdir}/. ${projectdir}
rm -rf ${tempdir}
    
cd ${projectdir}
#Set Scripts as executable & ensure everything is writeable
echo ".set any scripts as executable"
/source/AppDev-ContainerDemo/environment/set-scripts-executable.sh

#Reset DEMO Values
echo ".reset demo values"
/source/AppDev-ContainerDemo/environment/reset-demo-template-values.sh

echo ".finding appInsights Instrumentation key from Azure."
NODEJSTODOKEY=`~/bin/az resource show -g ossdemo-utility -n 'app Insight Nodejs-todo' --resource-type microsoft.insights/components --output json | jq '.properties.InstrumentationKey'`
NODEJSTODOKEY=("${NODEJSTODOKEY[@]//\"/}")  #REMOVE Quotes

echo ".editing the /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/server.js file with the new key: ${NODEJSTODOKEY}"
sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-NODEJSTODO-KEY@$NODEJSTODOKEY@g" /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/base.js

echo ".done"