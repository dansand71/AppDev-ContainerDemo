echo "-------------------------"
echo "This script is optional and deploys datadog monitoring on top of the ACS engine"
kubectl create -f K8S-datadog-deploy.yml
echo "-------------------------"



