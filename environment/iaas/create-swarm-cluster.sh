RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"
DEBUG="no"
#Create SWARM cluster.  For this demo the master is SVR1 and the worker is SVR2
#Open up ports TCP 2377 in ossdemo-utility and ossdemo-appdev-iaas
#Open up ports TCP & UDP 7946 in ossdemo-utility and ossdemo-appdev-iaas
#Open up ports UDP 4789 in ossdemo-utility and ossdemo-appdev-iaas

read -p "$(echo -e -n "${INPUT}Create NSG rules? [Y/n]${RESET}")" moveforward
if [[ ${moveforward,,} != "n" ]];then   

#UTILITY GROUP
 ~/bin/az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name docker-cluster-mgmt \
        --access Allow --protocol Tcp --direction Inbound --priority 210 --source-address-prefix "192.168.1.0/24" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 2377

~/bin/az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name docker-node-comms \
        --access Allow --protocol "*" --direction Inbound --priority 220 --source-address-prefix "192.168.1.0/24" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 7946

~/bin/az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name docker-cluster-ntwrk \
        --access Allow --protocol Udp --direction Inbound --priority 230 --source-address-prefix "192.168.1.0/24" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 4789

~/bin/az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name docker-cluster-visualizer \
        --access Allow --protocol Tcp --direction Inbound --priority 240 --source-address-prefix "*" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 8081

#This is for the eshop sql server to run on the master
~/bin/az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name eShopSQLBox \
        --access Allow --protocol Tcp --direction Inbound --priority 250 --source-address-prefix "192.168.1.0/24" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 5433
        

#IAAS GROUP
~/bin/az network nsg rule create --resource-group ossdemo-appdev-iaas --nsg-name NSG-ossdemo-appdev-iaas --name docker-cluster-mgmt \
        --access Allow --protocol Tcp --direction Inbound --priority 210 --source-address-prefix "192.168.0.0/24" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 2377

~/bin/az network nsg rule create --resource-group ossdemo-appdev-iaas --nsg-name NSG-ossdemo-appdev-iaas --name docker-node-comms \
        --access Allow --protocol "*" --direction Inbound --priority 220 --source-address-prefix "192.168.0.0/24" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 7946

~/bin/az network nsg rule create --resource-group ossdemo-appdev-iaas --nsg-name NSG-ossdemo-appdev-iaas --name docker-cluster-ntwrk \
        --access Allow --protocol Udp --direction Inbound --priority 230 --source-address-prefix "192.168.0.0/24" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 4789

~/bin/az network nsg rule create --resource-group ossdemo-appdev-iaas --nsg-name NSG-ossdemo-appdev-iaas --name http81-docker-swarm-demo \
        --access Allow --protocol Tcp --direction Inbound --priority 240 --source-address-prefix "*" \
        --source-port-range "*" --destination-address-prefix "*" --destination-port-range 81

fi

#masterip="$(/sbin/ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"
#sample if we make the master on SVR1 instead of the jumpbox
#masterip="$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@jumpbox-VALUEOF-UNIQUE-SERVER-PREFIX "/sbin/ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'")"
#FOR TESTING LOCALLY on CENTOS
masterip="$(/sbin/ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"
#FOR TESTING LOCALLY on WINDOWS we can just run: docker swarm init
echo "-------------------------"
echo "Cluster masterip"
echo ${masterip}
echo "-------------------------"
echo ""
echo "Create swarm on master"
echo "$(sudo docker swarm init --advertise-addr=${masterip})"
#echo "$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "sudo docker swarm init --advertise-addr=${masterip}")"
echo "-------------------------"
echo ""
echo "Get Join token from the master to apply to the worker nodes"
jointoken="$(sudo docker swarm join-token worker --quiet)"
#jointoken="$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-daVALUEOF-UNIQUE-SERVER-PREFIXnsand.eastus.cloudapp.azure.com "sudo docker swarm join-token worker --quiet")"
echo ${jointoken}
echo "-------------------------"
echo ""
echo "ssh into worker nodes and join the cluster"
sshcommand="sudo docker swarm join --token ${jointoken} ${masterip}:2377"
echo ${sshcommand}
echo ""
echo "Connecting to remote server 1"
echo "ssh -t -o BatchMode=yes -o StrictHostKeyChecking=no VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX ${sshcommand}"
outbound=`ssh -t -o BatchMode=yes -o StrictHostKeyChecking=no VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX ${sshcommand}`
echo ${outbound}
echo "Connecting to remote server 2"
echo "ssh -t -o BatchMode=yes -o StrictHostKeyChecking=no VALUEOF-DEMO-ADMIN-USER-NAME@svr2-VALUEOF-UNIQUE-SERVER-PREFIX ${sshcommand}"
outbound=`ssh -t -o BatchMode=yes -o StrictHostKeyChecking=no VALUEOF-DEMO-ADMIN-USER-NAME@svr2-VALUEOF-UNIQUE-SERVER-PREFIX ${sshcommand}`
echo ${outbound}

#install docker compose on the BUILD jumpbox
sudo curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /bin/docker-compose
sudo chmod +x /bin/docker-compose

#Create shared storage for docker swarm https://forums.docker.com/t/cloudstor-volume-plugin-missing/29080/12
echo ".Installing CLOUDSTOR Azure driver for shared storage."
STORAGEKEY=~/bin/az storage account keys list -g ossdemo-utility -n dansanddemostorage --query "[?keyName=='key1'] | [0].value" -o tsv
source /source/appdev-demo-EnvironmentTemplateValues
sudo docker plugin install --alias cloudstor:azure --grant-all-permissions docker4x/cloudstor:azure-v17.03.0-ce \
        CLOUD_PLATFORM=AZURE AZURE_STORAGE_ACCOUNT_KEY=$STORAGEKEY \
        AZURE_STORAGE_ACCOUNT=$DEMO_STORAGE_ACCOUNT


