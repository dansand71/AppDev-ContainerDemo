#!/bin/bash
echo "Deploy the OMS Daemonset to k8s for monitoring"
cd /source/AppDev-ContainerDemo/environment/acs

#~/bin/kubectl create -f OMSDaemonset.yml
# Now deploying the OMS Agent as a native extension vs the daemonset
