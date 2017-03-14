echo "Be sure to login to Azure prior to running this script."
#az account set --subscription "Microsoft Azure Internal Consumption"
echo "Create VM #1"
az vm create -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'svr1-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr21-VALUEOF-UNIQUE-SERVER-PREFIX-disk' --image "OpenLogic:CentOS:7.2:latest" --os-type linux --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2  --admin-username GBBOSSDemo \
        --nsg 'NSG-ossdemo-appdev-iaas' \
        #--availability-set 'ossdemo-appdev-iaas-availabilityset' \
        --no-wait \
        --ssh-key-value 'REPLACE-SSH-KEY' 

echo "Create VM #2"
az vm create -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'svr2-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr22-VALUEOF-UNIQUE-SERVER-PREFIX-disk' --image "OpenLogic:CentOS:7.2:latest" --os-type linux --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2 --admin-username GBBOSSDemo  \
        --nsg 'NSG-ossdemo-appdev-iaas' \
        #--availability-set 'ossdemo-appdev-iaas-availabilityset' \
        --no-wait \
        --ssh-key-value 'REPLACE-SSH-KEY'

#echo "Create VM #RHEL"
#az vm create -g 'ossdemo-appdev-iaas' -n svr3-VALUEOF-UNIQUE-SERVER-PREFIX \
#        --public-ip-address-dns-name 'svr3-VALUEOF-UNIQUE-SERVER-PREFIX' \
#        --os-disk-name 'svr3-VALUEOF-UNIQUE-SERVER-PREFIX-disk' --image "RedHat:RHEL:7.2:latest" --os-type linux --storage-sku 'Premium_LRS' \
#        --size Standard_DS1_v2 --admin-username GBBOSSDemo  \
#        --nsg 'NSG-ossdemo-appdev-iaas' --availability-set 'ossdemo-appdev-iaas-availabilityset' \
#        --no-wait \
#        --ssh-key-value 'REPLACE-SSH-KEY'
        
