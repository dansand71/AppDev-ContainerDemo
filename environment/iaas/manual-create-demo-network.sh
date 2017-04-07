echo "Create VNET & Subnet - "
## BUG BUG BUG - Ron Abellera - we need to find the CLI method for associating a Subnet in one RG with an NSG in another
~/bin/az network vnet create -n 'ossdemo-appdev-iaas-vnet' -g ossdemo-appdev-iaas --address-prefix 192.168.1.0/24
~/bin/az network vnet subnet create -g ossdemo-appdev-iaas --vnet-name ossdemo-appdev-iaas-vnet \
    -n ossdemo-appdev-iaas-subnet --address-prefix 192.168.1.0/24 

echo ""
echo "----------------------------------"
echo "Create Public IP Address and Load Balancers"
echo " running - az vm availability-set create -n ossdemo-appdev-iaas-availabilityset -g ossdemo-appdev-iaas --platform-update-domain-count 5 --platform-fault-domain-count 2"
~/bin/az vm availability-set create -n ossdemo-appdev-iaas-availabilityset -g ossdemo-appdev-iaas \
    --platform-update-domain-count 5 --platform-fault-domain-count 2

echo " Create public ip:"
echo "    running - az network public-ip create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicIP -l eastus --dns-name VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo --allocation-method Static"
~/bin/az network public-ip create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicIP -l eastus \
     --dns-name VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo --allocation-method Static

echo ""
echo "----------------------------------"
echo " Create load balancer:"
echo "    running - az network lb create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicLoadBalancer -l eastus --public-ip-address ossdemo-appdev-iaas-publicIP"
~/bin/az network lb create -g ossdemo-appdev-iaas -n ossdemo-appdev-iaas-publicLoadBalancer -l eastus \
    --public-ip-address ossdemo-appdev-iaas-publicIP

echo " Create backend address pool:"
echo "    running - az network lb address-pool create --lb-name ossdemo-appdev-iaas-publicLoadBalancer --name ossdemo-appdev-iaas-addresspool --resource-group ossdemo-appdev-iaas"
~/bin/az network lb address-pool create --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
    --name ossdemo-appdev-iaas-addresspool --resource-group ossdemo-appdev-iaas

echo " Create health probe:"
echo "    running - az network lb probe create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer --name HealthProbe80 --protocol tcp --port 80 --interval 15 --threshold 4"
~/bin/az network lb probe create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
    --name HealthProbe80 --protocol tcp --port 80 --interval 15 --threshold 4

echo " Create lb rule for port 80:"
echo "    running - az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer --name LoadBalancerRuleWeb --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool --probe-name HealthProbe80"
~/bin/az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
     --name LoadBalancerRuleWeb --protocol tcp --frontend-port 80 --backend-port 80 \
     --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool \
     --probe-name HealthProbe80

echo ""
echo "----------------------------------"
echo " Create network cards for servers:"
echo "    running - az network nic create --resource-group  ossdemo-appdev-iaas --location eastus --name svr1-nic --vnet-name 'ossdemo-appdev-iaas-vnet' --subnet ossdemo-appdev-iaas-subnet --network-security-group 'NSG-ossdemo-appdev-iaas' --lb-name ossdemo-appdev-iaas-publicLoadBalancer --lb-address-pools ossdemo-appdev-iaas-addresspool "
echo "Create Public IP Address for Svr 1"
echo "    running - az network public-ip create -g ossdemo-appdev-iaas -n svr1-publicIP -l eastus --dns-name svr1-VALUEOF-UNIQUE-SERVER-PREFIX --allocation-method Static"
~/bin/az network public-ip create -g ossdemo-appdev-iaas -n svr1-publicIP -l eastus \
      --dns-name svr1-VALUEOF-UNIQUE-SERVER-PREFIX --allocation-method Static

echo "----------------------------------"
echo "Create NIC for Svr 1"
~/bin/az network nic create --resource-group  ossdemo-appdev-iaas --location eastus --name svr1-nic \
       --vnet-name 'ossdemo-appdev-iaas-vnet' --subnet ossdemo-appdev-iaas-subnet --network-security-group 'NSG-ossdemo-appdev-iaas' \
       --lb-name ossdemo-appdev-iaas-publicLoadBalancer --lb-address-pools ossdemo-appdev-iaas-addresspool \
       --public-ip-address svr1-publicIP

echo "Create Public IP Address for Svr 2"
echo "    running - az network public-ip create -g ossdemo-appdev-iaas -n svr2-publicIP -l eastus --dns-name svr1-VALUEOF-UNIQUE-SERVER-PREFIX --allocation-method Static"
~/bin/az network public-ip create -g ossdemo-appdev-iaas -n svr2-publicIP -l eastus \
        --dns-name svr2-VALUEOF-UNIQUE-SERVER-PREFIX --allocation-method Static

echo "----------------------------------"
echo "Create NIC for Svr 2"
echo "    running - az network nic create --resource-group  ossdemo-appdev-iaas --location eastus --name svr2-nic --vnet-name 'ossdemo-appdev-iaas-vnet' --subnet ossdemo-appdev-iaas-subnet --network-security-group 'NSG-ossdemo-appdev-iaas' --lb-name ossdemo-appdev-iaas-publicLoadBalancer --lb-address-pools ossdemo-appdev-iaas-addresspool --public-ip-address svr2-publicIP"
~/bin/az network nic create --resource-group  ossdemo-appdev-iaas --location eastus --name svr2-nic \
         --vnet-name 'ossdemo-appdev-iaas-vnet' --subnet ossdemo-appdev-iaas-subnet --network-security-group 'NSG-ossdemo-appdev-iaas' \
         --lb-name ossdemo-appdev-iaas-publicLoadBalancer --lb-address-pools ossdemo-appdev-iaas-addresspool \
         --public-ip-address svr2-publicIP