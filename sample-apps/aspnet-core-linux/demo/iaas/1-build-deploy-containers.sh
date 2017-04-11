RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

#az account set --subscription "Microsoft Azure Internal Consumption"
echo -e "${BOLD}Create containers...${RESET}"
read -p "$(echo -e -n "${INPUT}Create and publish containers into Azure Private Registry? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/ansible/build-containers.sh
fi

echo -e "${BOLD}Deploy containers via ansible to worker iaas servers...${RESET}"
#change into the directory where the Ansible CFG is located
cd /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/ansible
ansible-playbook -i /source/AppDev-ContainerDemo/environment/iaas/hosts /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/iaas/ansible-docker-publish.yml

echo ""
echo -e "${BOLD}Browse application...${RESET}"
echo -e ".you can now browse the application at http://svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com for individual servers."
echo -e ". or at http://VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo.eastus.cloudapp.azure.com for a loadbalanced IP."