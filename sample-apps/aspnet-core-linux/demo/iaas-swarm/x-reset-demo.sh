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

read -p "$(echo -e -n "${INPUT}Delete NSG rules? [Y/n]${RESET}")" moveforward
if [[ ${moveforward,,} != "n" ]];then   

#UTILITY GROUP
~/bin/az network nsg rule delete --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name docker-cluster-mgmt 
~/bin/az network nsg rule delete --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name docker-node-comms       
~/bin/az network nsg rule delete --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name docker-cluster-ntwrk 
~/bin/az network nsg rule delte --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name docker-cluster-visualizer 

#IAAS GROUP
~/bin/az network nsg rule delete --resource-group ossdemo-appdev-iaas --nsg-name NSG-ossdemo-appdev-iaas --name docker-cluster-mgmt 
~/bin/az network nsg rule delete --resource-group ossdemo-appdev-iaas --nsg-name NSG-ossdemo-appdev-iaas --name docker-node-comms 
~/bin/az network nsg rule delete --resource-group ossdemo-appdev-iaas --nsg-name NSG-ossdemo-appdev-iaas --name docker-cluster-ntwrk 
~/bin/az network nsg rule delete --resource-group ossdemo-appdev-iaas --nsg-name NSG-ossdemo-appdev-iaas --name http81-docker-swarm-demo 

fi

echo "Leaving swarm on svr1 & 2"
echo "ssh -t -o BatchMode=yes -o StrictHostKeyChecking=no VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX 'sudo docker swarm leave'"
outbound=`ssh -t -o BatchMode=yes -o StrictHostKeyChecking=no VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX "sudo docker swarm leave"`
echo ${outbound}
outbound=`ssh -t -o BatchMode=yes -o StrictHostKeyChecking=no VALUEOF-DEMO-ADMIN-USER-NAME@svr2-VALUEOF-UNIQUE-SERVER-PREFIX "sudo docker swarm leave"`
echo ${outbound}

echo "Leave & Destroy swarm on jumpbox"
sudo docker swarm leave --force

