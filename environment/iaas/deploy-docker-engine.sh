echo "Calling Ansible to deploy the new docker engine to the VM's'"
#az account set --subscription "Microsoft Azure Internal Consumption"

cd /source/AppDev-ContainerDemo/environment
ansible-playbook -i hosts deploy-dockerengine-playbook.yml