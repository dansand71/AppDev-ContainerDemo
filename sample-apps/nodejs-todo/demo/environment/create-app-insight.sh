#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

#az account set --subscription "Microsoft Azure Internal Consumption"
echo -e "${BOLD}Creating App Insight Tracking...${RESET}"

~/bin/az group deployment create --resource-group ossdemo-utility --name InitialDeployment \
        --template-file /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/environment/ossdemo-utility-appinsights.json
      
NODEJSTODOKEY=`~/bin/az resource show -g ossdemo-utility -n 'app Insight Nodejs-todo' --resource-type microsoft.insights/components --output json | jq '.properties.InstrumentationKey'`
NODEJSTODOKEY=("${NODEJSTODOKEY[@]//\"/}")  #REMOVE Quotes

echo ".editing the /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/server.js file with the new key: ${NODEJSTODOKEY}"
sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-NODEJSTODO-KEY@$NODEJSTODOKEY@g" /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/server.js
