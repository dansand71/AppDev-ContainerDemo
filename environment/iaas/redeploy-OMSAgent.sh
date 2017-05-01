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
    ~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do sudo /opt/microsoft/omsagent/bin/omsadmin.sh -X & done
    ~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do sudo /opt/microsoft/omsagent/bin/omsadmin.sh -w VALUEOF-REPLACE-OMS-WORKSPACE -s VALUEOF-REPLACE-OMS-PRIMARYKEY & done
done
echo "Complete."