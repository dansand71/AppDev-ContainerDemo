#!/bin/bash
echo -e "\e[7mWelcome to the OSS Demo for Simple app dev Containers.  This demo will configure:\e[0m"
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
source /source/appdev-demo-EnvironmentTemplateValues
echo ""
echo -e "\e[7mCurrent Template Values:\e[0m"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX
echo "      DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
echo "      DEMO_REGISTRY_SERVER-NAME="$DEMO_REGISTRY_SERVER_NAME
echo "      DEMO_REGISTRY_USER_NAME="$DEMO_REGISTRY_USER_NAME
echo "      DEMO_REGISTRY_PASSWORD="$DEMO_REGISTRY_PASSWORD
echo "      DEMO_OMS_WORKSPACE="$DEMO_OMS_WORKSPACE
echo "      DEMO_OMS_PRIMARYKEY="$DEMO_OMS_PRIMARYKEY
echo "      DEMO_APPLICATION_INSIGHTS_KEY="$DEMO_APPLICATION_INSIGHTS_KEY
echo ""

if [[ -z $DEMO_UNIQUE_SERVER_PREFIX  ]]; then
   echo "   Server PREFIX is null.  Please correct and re-run this script.."
   exit
fi
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
echo -e "\e[7mConfirm Azure Subscription\e[0m"
read -p "Change default subscription? [y/N]:" changesubscription
if [[ $changesubscription =~ "y" ]];then
    read -p "      New Subscription Name:" newsubscription
    ~/bin/az account set --subscription "$newsubscription"
else
    echo "    Using default existing subscription."
fi

cd /source
#Leverage the existing public key for new VM creation script
echo "--------------------------------------------"
echo "Reading ~/.ssh/id_rsa.pub and writing values to /source/AppDev-ContainerDemo/*"
sshpubkey=$(< ~/.ssh/id_rsa.pub)
echo "Using public key:" ${sshpubkey}
sudo grep -rl REPLACE-SSH-KEY /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh | sudo xargs sed -i -e "s#REPLACE-SSH-KEY#$sshpubkey#g" 
echo "--------------------------------------------"

#RESET DEMO VALUES
echo -e "\e[7mConfiguring demo scripts with defaults.\e[0m"
/source/AppDev-ContainerDemo/environment/reset-demo-template-values.sh

echo "---------------------------------------------"
echo -e "\e[7mResource Group Creation\e[0m"
read -p "Apply JSON Templates for and network rules? [Y/n]:"  continuescript
if [[ $continuescript != "n" ]];then
    #BUILD RESOURCE GROUPS
    
    #APPLY JSON TEMPLATES
    echo -e "\e[7mApply ./environment/ossdemo-appdev-iaas.json template.\e[0m"
    ~/bin/az group deployment create --resource-group ossdemo-appdev-iaas --name InitialDeployment \
        --template-file /source/AppDev-ContainerDemo/environment/ossdemo-appdev-iaas.json
    
    echo -e "\e[7mApply ./environment/ossdemo-appdev-paas.json template.\e[0m"
    ~/bin/az group deployment create --resource-group ossdemo-appdev-paas --name InitialDeployment \
        --template-file /source/AppDev-ContainerDemo/environment/ossdemo-appdev-paas.json

    echo -e "\e[7mApply ./environment/ossdemo-utility-update-subnetNSG.json template.\e[0m"
    ~/bin/az group deployment create --resource-group ossdemo-utility --name UpdateVNETwithNewSubnetandNSG \
        --template-file /source/AppDev-ContainerDemo/environment/ossdemo-utility-update-subnetNSG.json

fi
echo -e "\e[7mCreate Demo Machines\e[0m"
read -p "Create AZ IAAS VM's & K8S Cluster? [Y/n]'"  precreate
if [[ $precreate != "n" ]];then
  ./sample-apps/aspnet-core-linux/setupdemo/iaas-demo/1-setup-demo.sh
  ./sample-apps/aspnet-core-linux/setupdemo/acs-demo/1-setup-demo.sh
fi

echo -e "\e[7mJUMPBOX Environment Setup\e[0m"
echo ".Copy desktop icons"
#Copy the desktop icons
sudo cp /source/AppDev-ContainerDemo/vm-assets/*.desktop ~/Desktop/
sudo chmod +x ~/Desktop/code.desktop
sudo chmod +x ~/Desktop/firefox.desktop
sudo chmod +x ~/Desktop/gnome-terminal.desktop

#do we have the latest verion of .net?
echo ".Installing libunwind libicu"
sudo yum install -qq libunwind libicu -y
echo ".Set the dotnet path variables"
echo "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc

#ensure .net is setup correctly
echo ".installing gcc libffi-devel python-devel openssl-devel"
sudo yum install -y -qq gcc libffi-devel python-devel openssl-devel
echo ".installing npm"
sudo yum install -qq -y npm
echo ".installing bower"
sudo npm install bower -g 
echo ".installing gulp"
sudo npm install gulp -g 

#configure the jumpbox with the latest docker version CE
echo ".Cleaning up older docker and now creating new version"
sudo yum remove docker docker-common container-selinux docker-selinux docker-engine -y
sudo yum update -y -qq
sudo yum upgrade -y -qq
sudo yum install -qq -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast
echo ".Installing Docker CE"
sudo yum install -qq docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker

#Install Docker Compose on the Jumpbox
echo ".Installing Docker Compose"
curl -L https://github.com/docker/compose/releases/download/1.12.0-rc1/docker-compose-`uname -s`-`uname -m` > ~/bin/docker-compose
chmod +x ~/bin/docker-compose

#Install Rimraf for Node Apps
echo ".Installing rimfraf, webpack, node-saas"
sudo npm install rimraf -g
sudo npm install webpack -g
sudo npm install node-sass -g

#reset file permissions
echo "CHMOD for Users on /source"
sudo chmod 777 -R /source

echo "Demo environment setup complete.  Please review demos found under /source/AppDev-ContainerDemo for IaaS, ACS and PaaS."