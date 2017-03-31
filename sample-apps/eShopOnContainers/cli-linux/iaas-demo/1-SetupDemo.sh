echo -p "Installing docker-machine on the jumpbox for managing the SWARM cluster"
curl -L https://github.com/docker/machine/releases/download/v0.10.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&  chmod +x /tmp/docker-machine &&  sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
read -p "Create network rules for demo's? [y/n]:"  continuescript
if [[ $continuescript != "n" ]];then

~/bin/az network nsg rule create --resource-group ossdemo-appdev-paas \
     --nsg-name NSG-ossdemo-appdev-paas --name http-rule \
     --access Allow --protocol Tcp --direction Inbound --priority 120 \
     --source-address-prefix Internet \
     --source-port-range "*" --destination-address-prefix "*" \
     --destination-port-range 5100-5105

fi


#Create SWARM cluster.  For this demo the master is SVR1 and the worker is SVR2
masterip="$(ssh GBBOSSDemo@svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "/sbin/ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'")"
echo "-------------------------"
echo "SVR1 masterip"
echo ${masterip}
echo "-------------------------"
echo ""
echo "Create swarm on SVR1"
echo "$(ssh GBBOSSDemo@svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "sudo docker swarm init --advertise-addr=${masterip}")"
echo "-------------------------"
echo ""
echo "Get Join token from the master to apply to the worker node on SVR2"
jointoken="$(ssh GBBOSSDemo@svr1-daVALUEOF-UNIQUE-SERVER-PREFIXnsand.eastus.cloudapp.azure.com "sudo docker swarm join-token worker --quiet")"
echo ${jointoken}
echo "-------------------------"
echo ""
echo "ssh into SVR2 server and join the cluster"
sshcommand="sudo docker swarm join --token ${jointoken} ${masterip}:2377"
echo ${sshcommand}
echo ""
echo "Connecting to remote server"
echo "ssh GBBOSSDemo@svr2-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "${sshcommand}""
outbound="$(ssh GBBOSSDemo@svr2-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "${sshcommand}")"
echo ${outbound}
