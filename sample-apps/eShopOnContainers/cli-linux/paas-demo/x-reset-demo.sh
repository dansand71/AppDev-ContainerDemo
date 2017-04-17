#!/bin/bash
echo "Delete the cluster from the worker then the master."
#az account set --subscription "Microsoft Azure Internal Consumption"
echo "Svr2 leave the swarm."
echo "$(ssh GBBOSSDemo@svr2-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "sudo docker swarm leave -f")"
echo "Svr1 leave the swarm."
echo "$(ssh GBBOSSDemo@svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "sudo docker swarm leave -f")"
echo ""
echo "completed cluster tear down."