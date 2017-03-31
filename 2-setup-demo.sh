#!/bin/bash
echo "Welcome to the OSS Demo for Simple app dev Containers.  This demo will configure:"
echo "    - Resource group - ossdemo-appdev-iaas"
echo "    - Resource group - ossdemo-appdev-acs"
echo "    - Resource group - ossdemo-appdev-paas"
echo "    - Create a private Azure Container Registry - used across all demos"
echo "    - Create an application insights instance - used across all demos"
echo "    - Optionally create an OMS instance - used across all demos"
echo ""
echo "It will also modify scripts for the demo and create:"
echo "     - 2 Servers in ossdemo-appdev-iaas - DEMO #1"
echo "     - 1 Kubernetes cluster in ossdemo-appdev-acs - DEMO #2"
echo "     - 1 Azure app service in ossdemo-appdev-paas - DEMO #3"
echo ""
echo "Installation & Configuration will require SU rights but pleae run this script as GBBOSSDemo."
echo ""
echo ""
echo ""
source /source/appdev-demo-EnvironmentTemplateValues
echo ""
echo "Current Template Values:"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX
echo "      DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
echo "      DEMO_REGISTRY_SERVER-NAME="$DEMO_REGISTRY_SERVER_NAME
echo "      DEMO_REGISTRY_USER_NAME="$DEMO_REGISTRY_USER_NAME
echo "      DEMO_REGISTRY_PASSWORD="$DEMO_REGISTRY_PASSWORD
echo "      DEMO_OMS_WORKSPACE="$DEMO_OMS_WORKSPACE
echo "      DEMO_OMS_PRIMARYKEY="$DEMO_OMS_PRIMARYKEY
echo "      DEMO_APPLICATION_INSIGHTS_KEY="$DEMO_APPLICATION_INSIGHTS_KEY
echo ""

echo "The remainder of this script requires the template values be filled in the /source/appdev-demo-EnvironmentTemplateValues file."
read -p "Press any key to continue or CTRL-C to exit... " startscript

echo "Logging in to Azure"
#Checking to see if we are logged into Azure
echo "    Checking if we are logged in to Azure."
#We need to redirect the output streams to stdout
azstatus=`~/bin/az group list 2>&1` 
if [[ $azstatus =~ "Please run 'az login' to setup account." ]]; then
   echo "   We need to login to azure.."
   az login
else
   echo "    Logged in."
fi
read -p "    Change default subscription? [y/n]:" changesubscription
if [[ $changesubscription =~ "y" ]];then
    read -p "      New Subscription Name:" newsubscription
    ~/bin/az account set --subscription "$newsubscription"
else
    echo "    Using default existing subscription."
fi

#Leverage the existing public key for new VM creation script
echo "--------------------------------------------"
echo "Reading ~/.ssh/id_rsa.pub and writing values to /source/AppDev-ContainerDemo/*"
sshpubkey=$(< ~/.ssh/id_rsa.pub)
echo "Using public key:" ${sshpubkey}
sudo grep -rl REPLACE-SSH-KEY /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh | sudo xargs sed -i -e "s#REPLACE-SSH-KEY#$sshpubkey#g" 
echo "--------------------------------------------"

echo "Configure demo scripts"
sudo echo "export ANSIBLE_HOST_KEY_CHECKING=false" >> ~/.bashrc
export ANSIBLE_HOST_KEY_CHECKING=false
cd /source
sudo grep -rl VALUEOF-UNIQUE-SERVER-PREFIX /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-SERVER-PREFIX@$DEMO_UNIQUE_SERVER_PREFIX@g"
sudo grep -rl VALUEOF-UNIQUE-STORAGE-ACCOUNT /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-STORAGE-ACCOUNT@$DEMO_STORAGE_ACCOUNT@g" 
sudo grep -rl VALUEOF-REGISTRY-SERVER-NAME /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-SERVER-NAME@$DEMO_REGISTRY_SERVER_NAME@g" 
sudo grep -rl VALUEOF-REGISTRY-USER-NAME /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-USER-NAME@$DEMO_REGISTRY_USER_NAME@g" 
sudo grep -rl VALUEOF-REGISTRY-PASSWORD /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-PASSWORD@$DEMO_REGISTRY_PASSWORD@g" 
sudo grep -rl VALUEOF-REPLACE-OMS-WORKSPACE /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-WORKSPACE@$DEMO_OMS_WORKSPACE@g" 
sudo grep -rl VALUEOF-REPLACE-OMS-PRIMARYKEY /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-PRIMARYKEY@$DEMO_OMS_PRIMARYKEY@g" 
sudo grep -rl VALUEOF-APPLICATION-INSIGHTS-KEY /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-KEY@$DEMO_APPLICATION_INSIGHTS_KEY@g"

echo ""
echo "---------------------------------------------"
echo ""
echo "Set values for creation of resource groups for container demo"
echo ""
read -p "Create resource group, and network rules? [y/n]:"  continuescript
if [[ $continuescript != "n" ]];then

    #BUILD RESOURCE GROUPS
    echo ""
    echo "BUILDING RESOURCE GROUPS"
    echo "--------------------------------------------"
    echo 'create ossdemo-appdev-iaas, ossdemo-appdev-acs, ossdemo-appdev-paas resource groups'
    ~/bin/az group create --name ossdemo-appdev-iaas --location eastus
    ~/bin/az group create --name ossdemo-appdev-acs --location eastus
    ~/bin/az group create --name ossdemo-appdev-paas --location eastus

    #BUILD NETWORKS SECURTIY GROUPS and RULES
    echo ""
    echo "BUILDING NETWORKS SECURTIY GROUPS and RULES"
    echo "--------------------------------------------"
    echo 'Network Security Groups (NSGs) for Resource Groups'
    ~/bin/az network nsg create --resource-group ossdemo-appdev-iaas --name NSG-ossdemo-appdev-iaas --location eastus
    ~/bin/az network nsg create --resource-group ossdemo-appdev-acs --name NSG-ossdemo-appdev-acs --location eastus
    ~/bin/az network nsg create --resource-group ossdemo-appdev-paas --name NSG-ossdemo-appdev-paas --location eastus

    echo 'Allow SSH inbound to iaas, acs and paas resource groups'
    ~/bin/az network nsg rule create --resource-group ossdemo-appdev-iaas \
        --nsg-name NSG-ossdemo-appdev-iaas --name ssh-rule \
        --access Allow --protocol Tcp --direction Inbound --priority 110 \
        --source-address-prefix Internet \
        --source-port-range "*" --destination-address-prefix "*" \
        --destination-port-range 22
    ~/bin/az network nsg rule create --resource-group ossdemo-appdev-iaas \
        --nsg-name NSG-ossdemo-appdev-iaas --name http-aspnetcoreDemo \
        --access Allow --protocol Tcp --direction Inbound --priority 120 \
        --source-address-prefix Internet \
        --source-port-range "*" --destination-address-prefix "*" \
        --destination-port-range 80

    ~/bin/az network nsg rule create --resource-group ossdemo-appdev-iaas \
        --nsg-name NSG-ossdemo-appdev-iaas --name http-eShopContainerDemo \
        --access Allow --protocol Tcp --direction Inbound --priority 130 \
        --source-address-prefix Internet \
        --source-port-range "*" --destination-address-prefix "*" \
        --destination-port-range 5100-5105

    ~/bin/az network nsg rule create --resource-group ossdemo-appdev-acs \
     --nsg-name NSG-ossdemo-appdev-acs --name ssh-rule \
     --access Allow --protocol Tcp --direction Inbound --priority 110 \
     --source-address-prefix Internet \
     --source-port-range "*" --destination-address-prefix "*" \
     --destination-port-range 22
     
    ~/bin/az network nsg rule create --resource-group ossdemo-appdev-paas \
     --nsg-name NSG-ossdemo-appdev-paas --name http-rule \
     --access Allow --protocol Tcp --direction Inbound --priority 120 \
     --source-address-prefix Internet \
     --source-port-range "*" --destination-address-prefix "*" \
     --destination-port-range 80
fi


#Copy the desktop icons
sudo cp /source/AppDev-ContainerDemo/vm-assets/*.desktop /home/GBBOSSDemo/Desktop/
sudo chmod +x /home/GBBOSSDemo/Desktop/code.desktop
sudo chmod +x /home/GBBOSSDemo/Desktop/firefox.desktop
sudo chmod +x /home/GBBOSSDemo/Desktop/gnome-terminal.desktop

#do we have the latest verion of .net?
sudo yum install libunwind libicu
curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=843449 
sudo mkdir -p /opt/dotnet && sudo tar zxf dotnet.tar.gz -C /opt/dotnet
sudo ln -s /opt/dotnet/dotnet /usr/local/bin
#set the dotnet path variables
echo "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc


#ensure .net is setup correctly
sudo yum install libunwind libicu
cd /source
curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=843449
sudo mkdir -p /opt/dotnet && sudo tar zxf dotnet.tar.gz -C /opt/dotnet
sudo ln -s /opt/dotnet/dotnet /usr/local/bin
sudo yum install -y gcc libffi-devel python-devel openssl-devel
sudo yum install -y npm
sudo npm install bower -g
sudo npm install gulp -g

#Set Scripts as executable
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/1-setup-demo.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/2-docker-setup.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/3-deploy-OMS-agent.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/4-build-deploy-containers.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/x-reset-demo.sh

sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/acs-demo/1-setup-demo.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/acs-demo/2-deploy-OMS-daemonset.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/acs-demo/3-deploy-expose-service.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/acs-demo/4-browse-k8s-cluster.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/acs-demo/5-republish.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/acs-demo/x-reset-demo.sh

sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/paas-demo/1-setup-demo.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/paas-demo/x-reset-demo.sh

sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/cli-linux/iaas-demo/1-setup-demo.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/cli-linux/iaas-demo/2-build-bits-linux.sh
sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/cli-linux/iaas-demo/x-reset-demo.sh

sudo chmod +x /source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/x-reset-all-demos.sh

#configure the jumpbox with the latest docker version CE
sudo yum remove docker docker-common container-selinux docker-selinux docker-engine -y
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast
sudo yum install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker

#Install Docker Compose on the Jumpbox
curl -L https://github.com/docker/compose/releases/download/1.12.0-rc1/docker-compose-`uname -s`-`uname -m` > ~/bin/docker-compose
chmod +x ~/bin/docker-compose

#Install Rimraf for Node Apps
sudo npm install rimraf -g
sudo npm install webpack -g
sudo npm install node-sass -g

#reset file permissions
sudo chmod 777 -R /source

echo " Demo environment setup complete.  Please review demos found under /source/AppDev-ContainerDemo for IaaS, ACS and PaaS."