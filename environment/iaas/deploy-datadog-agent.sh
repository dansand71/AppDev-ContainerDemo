echo "Calling Ansible to deploy datadog monitoring"
#az account set --subscription "Microsoft Azure Internal Consumption"

cd /source/AppDev-ContainerDemo/environment/iaas
ansible-playbook -i hosts deploy-datadog-agent.yml