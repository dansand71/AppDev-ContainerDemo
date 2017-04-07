echo "This script leverages Ansible to deploy the new docker host to the VM's created in step 1'"
#az account set --subscription "Microsoft Azure Internal Consumption"

cd /source/AppDev-ContainerDemo/environment
ansible-playbook -i hosts deploy-OMSAgent-playbook.yml