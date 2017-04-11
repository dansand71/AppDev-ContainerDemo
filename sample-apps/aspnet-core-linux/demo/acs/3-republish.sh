#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

#In this demo we dont use version on our image tags  (not a best practice)
# so in order to trigger the refresh we need to alter the image name by rotating :latest from the end of the image tag
if grep -q aspnet-core-linux:latest /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/acs/K8S-deploy-file.yml; then
    #if it is :latest remove it
    sudo sed -i -e "s@image: VALUEOF-REGISTRY-SERVER-NAME/ossdemo/aspnet-core-linux:latest@image: VALUEOF-REGISTRY-SERVER-NAME/ossdemo/aspnet-core-linux@g" /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/acs/K8S-deploy-file.yml
   else
    #add :latest
    sudo sed -i -e "s@image: VALUEOF-REGISTRY-SERVER-NAME/ossdemo/aspnet-core-linux@image: VALUEOF-REGISTRY-SERVER-NAME/ossdemo/aspnet-core-linux:latest@g" /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/acs/K8S-deploy-file.yml
 fi

echo -e "${BOLD}Recreate containers...${RESET}"
read -p "$(echo -e -n "${INPUT}Recreate and publish containers into Azure Private Registry? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/ansible/build-containers.sh
fi
echo -e "${BOLD}Force a rolling update with Kubernetes...${RESET}"
echo "Trigger a K8S refresh"
kubectl rolling-update aspnet-core-linux --image VALUEOF-REGISTRY-SERVER-NAME/ossdemo/aspnet-core-linux:latest --image-pull-policy Always