read -p "Create network rules for demo's? [y/n]:"  continuescript
if [[ $continuescript != "n" ]];then

~/bin/az network nsg rule create --resource-group ossdemo-appdev-paas \
     --nsg-name NSG-ossdemo-appdev-paas --name http-rule \
     --access Allow --protocol Tcp --direction Inbound --priority 120 \
     --source-address-prefix Internet \
     --source-port-range "*" --destination-address-prefix "*" \
     --destination-port-range 5100-5105

fi
