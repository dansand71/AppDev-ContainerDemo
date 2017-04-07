#!/bin/bash
echo "Delete the service and deployment which will cleanup the pods and external IP's'"
#az account set --subscription "Microsoft Azure Internal Consumption"
kubectl delete service aspnet-core-linux
kubectl delete deployment aspnet-core-linux-deployment