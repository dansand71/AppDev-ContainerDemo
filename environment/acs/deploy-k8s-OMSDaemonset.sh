#!/bin/bash
echo "Deploy the OMS Daemonset to k8s for monitoring"
~/bin/kubectl create -f OMSDaemonset.yml
