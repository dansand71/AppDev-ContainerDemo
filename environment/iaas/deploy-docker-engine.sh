echo "Calling Ansible to deploy the new docker engine to the VM's'"
#az account set --subscription "Microsoft Azure Internal Consumption"

ansible-playbook -i hosts deploy-dockerengine-playbook.yml