#!/bin/bash
echo "Force a refresh of the containers"
#az account set --subscription "Microsoft Azure Internal Consumption"

cd /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/demo/acs
ansible-playbook -i /source/AppDev-ContainerDemo/environment/iaas/hosts ansible-docker-publish.yml