#!/bin/bash
echo "Delete the service and deployment which will cleanup the pods and external IP's'"
#az account set --subscription "Microsoft Azure Internal Consumption"
kubectl delete service xxx
kubectl delete service xxx
kubectl delete deployment xxx
kubectl delete deployment xxx
