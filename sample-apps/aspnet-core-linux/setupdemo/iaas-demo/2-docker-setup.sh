echo "This script leverages Ansible to deploy the new docker host to the VM's created in step 1'"
#az account set --subscription "Microsoft Azure Internal Consumption"

ansible-playbook -i hosts ansible-docker-setup.yml