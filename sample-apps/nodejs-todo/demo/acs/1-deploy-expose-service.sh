#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

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

echo "To scale: kubectl scale --replicas=3 deployment/nodejs-todo-deployment"
echo "To debug: kubectl log <pod name>"
echo "To bash : kubectl exec -p <pod name> -i -t -- bash -il"
echo "Service : kubectl get services"
echo "Pods    : kubectl get pods"

