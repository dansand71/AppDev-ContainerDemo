#!/bin/bash
echo "Browse the K8S Cluster"
#az account set --subscription "Microsoft Azure Internal Consumption"
az acs kubernetes browse -n k8s-VALUEOF-UNIQUE-SERVER-PREFIX -g ossdemo-appdev-acs
