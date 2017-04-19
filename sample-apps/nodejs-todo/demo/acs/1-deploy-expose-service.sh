#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

#az account set --subscription "Microsoft Azure Internal Consumption"
#reset the database connection string in case it has changed
echo "module.exports = {
    remoteUrl : 'mongodb://nosqlsvc:27017/todo',
    localUrl: 'mongodb://nosqlsvc:27017/todo'
};" > /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/database.js

#
echo -e "${BOLD}Create containers...${RESET}"
read -p "$(echo -e -n "${INPUT}Create and publish containers into Azure Private Registry? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/ansible/build-containers.sh
fi

echo "-------------------------"
echo "Deploy the app deployment"
kubectl create -f K8S-deploy-file.yml
echo "-------------------------"

echo "Initial deployment & expose the service"
kubectl expose deployments nosqlsvc-deployment --port=27017 --target-port=27017 --name=nosqlsvc
kubectl expose deployments nodejs-todo-deployment --port=80 --target-port=8080 --type=LoadBalancer --name=nodejs-todo

echo "Deployment complete for pods: nodejs-todo & nosqlsvc"

echo ".kubectl get services"
kubectl get services

echo ".kubectl get pods"
kubectl get pods


