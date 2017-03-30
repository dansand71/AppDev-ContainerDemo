#!/bin/bash
#az account set --subscription "Microsoft Azure Internal Consumption"
echo "Deploy the app deployment"
kubectl create -f K8S-deploy-file.yml

echo "Initial deployment & expose the service"
kubectl expose deployments aspnet-core-linux-deployment \
        --port=80 --target-port=5000 \
        --type=LoadBalancer \
        --name=aspnet-core-linux
