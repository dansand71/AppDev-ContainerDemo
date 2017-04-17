echo "    running - az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer --name LoadBalancerRuleWeb --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool --probe-name HealthProbe80"
~/bin/az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
     --name LBeShop5100 --protocol tcp --frontend-port 5100 --backend-port 5100 \
     --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool \
     --probe-name HealthProbe80

~/bin/az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
     --name LBeShop5101 --protocol tcp --frontend-port 5101 --backend-port 5101 \
     --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool \
     --probe-name HealthProbe80

~/bin/az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
     --name LBeShop5102 --protocol tcp --frontend-port 5102 --backend-port 5102 \
     --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool \
     --probe-name HealthProbe80

~/bin/az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
     --name LBeShop5103 --protocol tcp --frontend-port 5103 --backend-port 5103 \
     --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool \
     --probe-name HealthProbe80

~/bin/az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
     --name LBeShop5104 --protocol tcp --frontend-port 5104 --backend-port 5104 \
     --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool \
     --probe-name HealthProbe80

~/bin/az network lb rule create --resource-group ossdemo-appdev-iaas --lb-name ossdemo-appdev-iaas-publicLoadBalancer \
     --name LBeShop5105 --protocol tcp --frontend-port 5105 --backend-port 5105 \
     --frontend-ip-name LoadBalancerFrontEnd --backend-pool-name ossdemo-appdev-iaas-addresspool \
     --probe-name HealthProbe80

#This is for the eshop sql server to run on the master
~/bin/az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name eShopSQLBox \
        --access Allow --protocol Tcp --direction Inbound --priority 250 --source-address-prefix "192.168.1.0/24" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 5433