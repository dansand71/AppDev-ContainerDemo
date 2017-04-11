#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

echo -e "${BOLD}Recreate containers...${RESET}"
read -p "$(echo -e -n "${INPUT}Recreate and publish containers into Azure Private Registry? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/ansible/build-containers.sh
fi
echo -e "${BOLD}Force a rolling update with Kubernetes...${RESET}"
echo "Trigger a K8S refresh"
kubectl rolling-update aspnet-core-linux --image VALUEOF-REGISTRY-SERVER-NAME/ossdemo/aspnet-core-linux:latest --image-pull-policy Always