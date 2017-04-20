#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

#az account set --subscription "Microsoft Azure Internal Consumption"

read -p "$(echo -e -n "${INPUT}Create new App Insight resource into ossdemo-utility resource group? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
   ~/bin/az group deployment create --resource-group ossdemo-utility --name InitialDeployment \
        --template-file /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/environment/ossdemo-utility-appinsights.json
fi
echo ".finding appInsights Instrumentation key from Azure."
NODEJSTODOKEY=`~/bin/az resource show -g ossdemo-utility -n 'app Insight Nodejs-todo' --resource-type microsoft.insights/components --output json | jq '.properties.InstrumentationKey'`
NODEJSTODOKEY=("${NODEJSTODOKEY[@]//\"/}")  #REMOVE Quotes

echo ".editing the /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/server.js file with the new key: ${NODEJSTODOKEY}"
sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-NODEJSTODO-KEY@$NODEJSTODOKEY@g" /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/server.js
