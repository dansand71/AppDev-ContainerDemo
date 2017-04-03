echo "Be sure to login to Azure prior to running this script."
#az account set --subscription "Microsoft Azure Internal Consumption"

echo "Creating Docker Runtime hosts for Demo #1"
read -p "Create vnet, publicIP and loadbalancer?  Typically this is only needed the first time you run the demo. [y/n]:"  continuescript
if [[ $continuescript != "n" ]];then
        echo ""
        echo "----------------------------------"
        echo "Create Subnet - "
        az network vnet subnet create -g ossdemo-appdev-iaas --vnet-name ossdemos-vnet -n ossdemo-appdev-iaas-subnet --address-prefix 192.168.1.0/24 --network-security-group NSG-ossdemo-appdev-iaas
        
        echo ""
        echo "----------------------------------"
        echo "Create Public IP Address and Load Balancers"
                echo " running - az vm availability-set create -n ossdemo-appdev-iaas-availabilityset -g ossdemo-appdev-iaas --platform-update-domain-count 5 --platform-fault-domain-count 2"
                az vm availability-set create -n ossdemo-appdev-iaas-availabilityset -g ossdemo-appdev-iaas \
                        --platform-update-domain-count 5 --platform-fault-domain-count 2
                echo " Create public ip:"
                echo "    running - az network public-ip create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicIP -l eastus --dns-name VALUEOF-UNIQUE-SERVER-PREFIX --allocation-method Static"
                az network public-ip create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicIP -l eastus \
                        --dns-name VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo --allocation-method Static
        echo ""
        echo "----------------------------------"
        echo " Create load balancer:"
                
                echo "    running - az network lb create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicLoadBalancer -l eastus --public-ip-address ossdemo-appdev-iaas-publicIP"
                az network lb create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicLoadBalancer -l eastus --public-ip-address ossdemo-appdev-iaas-publicIP
                
                echo " Create backend address pool:"
                echo "    running - az network lb address-pool create --lb-name ossdemo-appdev-iaas-publicLoadBalancer --name ossdemo-appdev-iaas-addresspool --resource-group ossdemo-appdev-iaas"
                az network lb address-pool create --lb-name ossdemo-appdev-iaas-publicLoadBalancer --name ossdemo-appdev-iaas-addresspool --resource-group ossdemo-appdev-iaas
                
                echo " Create health probe:"
                echo "    running - az network lb probe create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer --name HealthProbe80 --protocol tcp --port 80 --interval 15 --threshold 4"
                az network lb probe create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
                        --name HealthProbe80 --protocol tcp --port 80 --interval 15 --threshold 4
                
                echo " Create lb rule for port 80:"
                echo "    running - az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer --name LoadBalancerRuleWeb --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool --probe-name HealthProbe80"
                az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
                        --name LoadBalancerRuleWeb --protocol tcp --frontend-port 80 --backend-port 80 \
                        --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool \
                        --probe-name HealthProbe80
        
        echo ""
        echo "----------------------------------"
        echo " Create network cards for servers:"
        echo "    running - az network nic create --resource-group  ossdemo-appdev-iaas --location eastus --name svr1-nic --vnet-name 'ossdemo-appdev-iaas-vnet' --subnet ossdemo-appdev-iaas-subnet --network-security-group 'NSG-ossdemo-appdev-iaas' --lb-name ossdemo-appdev-iaas-publicLoadBalancer --lb-address-pools ossdemo-appdev-iaas-addresspool "
        
        echo "Create Public IP Address for Svr 1"
                echo "    running - az network public-ip create -g ossdemo-appdev-iaas -n svr1-publicIP -l eastus --dns-name svr1-VALUEOF-UNIQUE-SERVER-PREFIX --allocation-method Static"
                az network public-ip create -g ossdemo-appdev-iaas -n svr1-publicIP -l eastus --dns-name svr1-VALUEOF-UNIQUE-SERVER-PREFIX --allocation-method Static
        echo ""
        echo "----------------------------------"
        echo "Create NIC for Svr 1"
        az network nic create --resource-group  ossdemo-appdev-iaas --location eastus --name svr1-nic \
                --vnet-name 'ossdemos-vnet' --subnet ossdemo-appdev-iaas-subnet --network-security-group 'NSG-ossdemo-appdev-iaas' \
                --lb-name ossdemo-appdev-iaas-publicLoadBalancer --lb-address-pools ossdemo-appdev-iaas-addresspool \
                --public-ip-address svr1-publicIP
        
        echo "Create Public IP Address for Svr 2"
        echo "    running - az network public-ip create -g ossdemo-appdev-iaas -n svr2-publicIP -l eastus --dns-name svr1-VALUEOF-UNIQUE-SERVER-PREFIX --allocation-method Static"
        az network public-ip create -g ossdemo-appdev-iaas -n svr2-publicIP -l eastus --dns-name svr2-VALUEOF-UNIQUE-SERVER-PREFIX --allocation-method Static
        
        echo ""
        echo "----------------------------------"
        echo "Create NIC for Svr 2"
        echo "    running - az network nic create --resource-group  ossdemo-appdev-iaas --location eastus --name svr2-nic --vnet-name 'ossdemo-appdev-iaas-vnet' --subnet ossdemo-appdev-iaas-subnet --network-security-group 'NSG-ossdemo-appdev-iaas' --lb-name ossdemo-appdev-iaas-publicLoadBalancer --lb-address-pools ossdemo-appdev-iaas-addresspool --public-ip-address svr2-publicIP"
        az network nic create --resource-group  ossdemo-appdev-iaas --location eastus --name svr2-nic \
                --vnet-name 'ossdemos-vnet' --subnet ossdemo-appdev-iaas-subnet --network-security-group 'NSG-ossdemo-appdev-iaas' \
                --lb-name ossdemo-appdev-iaas-publicLoadBalancer --lb-address-pools ossdemo-appdev-iaas-addresspool \
                --public-ip-address svr2-publicIP
fi

echo ""
echo "----------------------------------"
echo "Create VM #1 & add it to the availability set and vnet"
az vm create -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'svr1-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr1-disk' --image "OpenLogic:CentOS:7.2:latest" --storage-sku 'Premium_LRS' \
        --size Standard_DS2_v2  --admin-username GBBOSSDemo \
        --availability-set 'ossdemo-appdev-iaas-availabilityset' \
        --nics svr1-nic \
        --no-wait \
        --ssh-key-value 'REPLACE-SSH-KEY' 
echo ""
echo "----------------------------------"
echo "Create VM #2 & add it to the availability set and vnet"
az vm create -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'svr2-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr2-disk' --image "OpenLogic:CentOS:7.2:latest" --storage-sku 'Premium_LRS' \
        --size Standard_DS2_v2 --admin-username GBBOSSDemo  \
        --availability-set 'ossdemo-appdev-iaas-availabilityset' \
        --nics svr2-nic \
        --no-wait \
        --ssh-key-value 'REPLACE-SSH-KEY'


#echo "Create VM #RHEL"
#az vm create -g 'ossdemo-appdev-iaas' -n svr3-VALUEOF-UNIQUE-SERVER-PREFIX \
#        --public-ip-address-dns-name 'svr3-VALUEOF-UNIQUE-SERVER-PREFIX' \
#        --os-disk-name 'svr3-disk' --image "RedHat:RHEL:7.2:latest" --os-type linux --storage-sku 'Premium_LRS' \
#        --size Standard_DS1_v2 --admin-username GBBOSSDemo  \
#        --nsg 'NSG-ossdemo-appdev-iaas' --availability-set 'ossdemo-appdev-iaas-availabilityset' \
#        --no-wait \
#        --ssh-key-value 'REPLACE-SSH-KEY'
        
