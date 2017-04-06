#Create SWARM cluster.  For this demo the master is SVR1 and the worker is SVR2
#masterip="$(/sbin/ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"
#sample if we make the master on SVR1 instead of the jumpbox
masterip="$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "/sbin/ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'")"
#FOR TESTING LOCALLY on CENTOS
#masterip="$(/sbin/ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'")"
#FOR TESTING LOCALLY on WINDOWS we can just run: docker swarm init
echo "-------------------------"
echo "Cluster masterip"
echo ${masterip}
echo "-------------------------"
echo ""
echo "Create swarm on master"
#echo "$(sudo docker swarm init --advertise-addr=${masterip})"
echo "$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "sudo docker swarm init --advertise-addr=${masterip}")"
echo "-------------------------"
echo ""
echo "Get Join token from the master to apply to the worker nodes"
#jointoken="$(sudo docker swarm join-token worker --quiet)"
jointoken="$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-daVALUEOF-UNIQUE-SERVER-PREFIXnsand.eastus.cloudapp.azure.com "sudo docker swarm join-token worker --quiet")"
echo ${jointoken}
echo "-------------------------"
echo ""
echo "ssh into worker nodes and join the cluster"
sshcommand="sudo docker swarm join --token ${jointoken} ${masterip}:2377"
echo ${sshcommand}
echo ""
echo "Connecting to remote server 1"
#echo "ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "${sshcommand}""
#outbound="$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "${sshcommand}")"
#echo ${outbound}
echo "Connecting to remote server 2"
echo "ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr2-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "${sshcommand}""
outbound="$(ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr2-VALUEOF-UNIQUE-SERVER-PREFIX.eastus.cloudapp.azure.com "${sshcommand}")"
echo ${outbound}

#install docker compose on the BUILD jumpbox
sudo curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose