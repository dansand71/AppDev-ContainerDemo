#!/bin/bash
rgList=(
    "ossdemo-appdev-iaas"
    "ossdemo-appdev-acs"
    "ossdemo-appdev-oshift"
)

for rg in "${rgList[@]}"
do
    echo -e "\e[33mWorking on rg:$rg"
    ~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do ~/bin/az vm deallocate -g $rg -n $i -o tsv 2>&1 | tee -a azure.log & done
    popd
done
echo "Complete."


