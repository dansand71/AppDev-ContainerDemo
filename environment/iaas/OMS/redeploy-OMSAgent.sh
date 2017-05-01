#!/bin/bash
rgList=(
    "ossdemo-appdev-iaas"
    #"ossdemo-appdev-acs"  -- This is already deployed via the OMS Daemonset
    "ossdemo-appdev-oshift"
    "ossdemo-utility"
)

for rg in "${rgList[@]}"
do
    echo -e "\e[33mWorking on rg:$rg"
    echo -e "reconfiguring oms agents"
    #~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do ansible-playbook deploy-OMSAgent-playbook.yml -i $i, & done
    ~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do az vm extension set --publisher Microsoft.EnterpriseCloud.Monitoring --resource-group $rg --vm-name $i --name OmsAgentForLinux --version 1.0 --public-config-path public.json --private-config-path protected.json & done
    
    if [$rg == "ossdemo-appdev-oshift" ] ; then
    echo "installing OMS Agent for the first time to all Openshift agent vm's."
        #~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do ansible-playbook redeploy-OMSAgent-playbook.yml -i $i, & done
    fi
    
done

echo "uninstalling the OMS Daemonset from ACS and redeploying."
kubectl delete daemonset OMSAgent
/source/AppDev-ContainerDemo/environment/acs/deploy-k8s-OMSDaemonset.sh
echo "completed oms agent install for K8s."
echo "Complete."