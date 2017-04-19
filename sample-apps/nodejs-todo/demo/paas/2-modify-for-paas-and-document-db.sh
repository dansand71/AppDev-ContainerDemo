#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

#az account set --subscription "Microsoft Azure Internal Consumption"
echo "-------------------------"
echo "Modify /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/database.js for remote documentDB"
#Change connection string in code - we can also move this to an ENV variable instead
DOCUMENTDBKEY=`~/bin/az documentdb list-connection-strings -g ossdemo-appdev-paas -n VALUEOF-UNIQUE-SERVER-PREFIX-documentdb --query connectionStrings[].connectionString -o tsv`
sed -i -e "s|mongodb://nosqlsvc:27017/todo|${DOCUMENTDBKEY}|g" /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/database.js

echo -e "${BOLD}Pushing code to app service...${RESET}"

echo ".attempting to push code to azure"
cd /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src
#this tag was created in the initial demo setup ../1-setup-demo.sh
git push nodejs-todo-azure-appsvc master


