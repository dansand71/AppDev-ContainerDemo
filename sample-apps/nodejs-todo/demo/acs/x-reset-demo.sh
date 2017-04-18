#!/bin/bash
echo "Delete the service and deployment which will cleanup the pods and external IP's'"
#az account set --subscription "Microsoft Azure Internal Consumption"
kubectl delete service nodejs-todo
kubectl delete service nosqlsvc
kubectl delete deployment nodejs-todo-deployment
kubectl delete deployment nosqlsvc-deployment
