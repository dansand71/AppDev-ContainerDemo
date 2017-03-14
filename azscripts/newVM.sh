echo "Be sure to login to Azure prior to running this script."
#az account set --subscription "Microsoft Azure Internal Consumption"

echo "Create Public IP Address and Load Balancers"
az vm availability-set create -n ossdemo-appdev-iaas-availabilityset -g ossdemo-appdev-iaas --platform-update-domain-count 5 --platform-fault-domain-count 2
#az network public-ip create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicIP -l eastus --dns-name VALUEOF-UNIQUE-SERVER-PREFIX
#az network lb create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicLoadBalancer -l eastus --public-ip-address ossdemo-appdev-iaas-publicIP
#az network lb address-pool create --lb-name ossdemo-appdev-iaas-publicLoadBalancer --name ossdemo-appdev-iaas-addresspool --resource-group ossdemo-appdev-iaas


echo "Create VM #1"
az vm create -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'svr1-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr21-disk' --image "OpenLogic:CentOS:7.2:latest" --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2  --admin-username GBBOSSDemo \
        --nsg 'NSG-ossdemo-appdev-iaas' \
        --availability-set 'ossdemo-appdev-iaas-availabilityset' \
        --no-wait \
        --ssh-key-value 'REPLACE-SSH-KEY' 

echo "Create VM #2"
az vm create -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'svr2-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr22-disk' --image "OpenLogic:CentOS:7.2:latest" --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2 --admin-username GBBOSSDemo  \
        --nsg 'NSG-ossdemo-appdev-iaas' \
        --availability-set 'ossdemo-appdev-iaas-availabilityset' \
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
        
