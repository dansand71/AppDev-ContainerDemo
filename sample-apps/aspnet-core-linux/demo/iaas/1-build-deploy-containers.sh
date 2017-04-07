echo "This script leverages Ansible to deploy the new docker host to the VM's created in step 1'"
#az account set --subscription "Microsoft Azure Internal Consumption"

#change into the directory where the Ansible CFG is located
cd /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/iaas
ansible-playbook -i /source/AppDev-ContainerDemo/environment/iaas/hosts ansible-docker-publish.yml