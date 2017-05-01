#!/bin/bash
rgList=(
    "ossdemo-appdev-iaas"
    "ossdemo-appdev-acs"
    "ossdemo-appdev-oshift"
    "ossdemo-utility"
)

for rg in "${rgList[@]}"
do
    echo -e "\e[33mWorking on rg:$rg"
    ~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do ansible-playbook redeploy-OMSAgent-playbook.yml -i $i & done
done
echo "Complete."