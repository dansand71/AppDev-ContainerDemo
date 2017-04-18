#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

#az account set --subscription "Microsoft Azure Internal Consumption"
echo -e "${BOLD}Create Document DB?...${RESET}"
read -p "$(echo -e -n "${INPUT}Create new DocumentDB resource into ossdemo-utility resource group? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    ~/bin/az documentdb create --name VALUEOF-UNIQUE-SERVER-PREFIX-documentdb --resource-group ossdemo-appdev-paas --kind MongoDB
fi
echo "-------------------------"
echo "Ensuring App Insights is configured."
/source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/environment/create-app-insight.sh
echo "-------------------------"
echo "Modify /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/database.js for remote documentDB"
#Change connection string in code - we can also move this to an ENV variable instead
DOCUMENTDBKEY='~/bin/az documentdb list-connection-strings -g ossdemo-appdev-paas -n VALUEOF-UNIQUE-SERVER-PREFIX-documentdb --query connectionStrings[].connectionString -o tsv'
echo ".working with documentdbkey:${DOCUMENTDBKEY}"
sed -i -e "s|mongodb://nosqlsvc:27017/todo|$DOCUMENTDBKEY|g" /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/database.js

#BUILD Container & publish to registry
read -p "$(echo -e -n "${INPUT}Create and publish containers into Azure Private Registry? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/ansible/build-docdb-containers.sh
fi

#Delete existing K8S Service & Redeploy
cd /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/paas
echo "deleting existing nodejs deployment "
./x-reset-demo.sh
echo "-------------------------"
echo "Deploy the app deployment"
kubectl create -f K8S-deploy-file.yml
echo "-------------------------"

echo "Initial deployment & expose the service"
kubectl expose deployments nodejs-todo-with-documentdb-deployment --port=80 --target-port=8080 --type=LoadBalancer --name=nodejs-todo-with-documentdb

echo "Deployment complete."

echo ".kubectl get services"
kubectl get services

echo ".kubectl get pods"
kubectl get pods
