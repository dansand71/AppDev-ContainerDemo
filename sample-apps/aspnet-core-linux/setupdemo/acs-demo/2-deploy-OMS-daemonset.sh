#!/bin/bash
echo "Deploy the OMS Daemonset for monitoring"
kubectl create -f K8S-OMS-Deploy.yml
