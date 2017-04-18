echo "This script builds and deploys the nodejs into a container and places it into the Azure Registry."
#az account set --subscription "Microsoft Azure Internal Consumption"

#change into the directory where the Ansible CFG is located
cd /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/ansible
ansible-playbook -i /source/AppDev-ContainerDemo/environment/iaas/hosts build-publish-containers.yml