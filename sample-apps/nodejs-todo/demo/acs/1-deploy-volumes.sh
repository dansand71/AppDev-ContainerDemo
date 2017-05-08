#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

echo -e "${BOLD}Create containers...${RESET}"
read -p "$(echo -e -n "${INPUT}Create and publish containers into Azure Private Registry? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    #Delete existing App Insight directory
    /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/ansible/build-containers.sh
fi

echo "-------------------------"
echo "Remove existing Volumes"
kubectl delete pvc nosql-pv


echo "-------------------------"
echo "Deploy the new volumes - this can take up to 10 minutes to format the drives the first time"
kubectl create -f pv-nosql.yml
echo "-------------------------"

echo "Deployment complete for pvc's'"

echo ".kubectl get services"
kubectl get pvc
kubectl get pv


echo "Please ensure the drives are bound and ready before deploying NodeJS and MongoDB."