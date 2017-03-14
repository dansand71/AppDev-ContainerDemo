echo "Welcome to the OSS Demo for Simple app dev Containers.  This demo will configure:"
echo "    - Resource group - ossdemo-appdev-iaas"
echo "    - Resource group - ossdemo-appdev-acs"
echo "    - Resource group - ossdemo-appdev-paas"
echo ""
echo "It will also modify scripts for the demo and download the GIT repository and create:"
echo "     - Servers in ossdemo-appdev-iaas"
echo "     - Kubernetes cluster in ossdemo-appdev-acs"
echo "     - Azure app service in ossdemo-appdev-paas"
echo ""
echo "Installation & Configuration will require SU rights but pleae run this script as GBBOSSDemo."
echo ""
echo "Upon download please edit /source/AppDev-ContainerDemo/vm-assets/DemoEnvironmentTemplateValues file with your unique values."
echo ""
echo ""
echo "Installing AZ command line tools if they are missing."

#Check to see if Azure is installed if not do it.  You will have to rerun the setup script after...
if [ -f ~/bin/az ]
  then
    echo "    AZ Client installed. Skipping install.."
  else
    echo "    Need to install Azure Tools.  After completion please re-run the script."
    curl -L https://aka.ms/InstallAzureCli | bash
    echo "Please rerun the script now that you have installed the Azure Tools"
    exit
fi
echo "Logging in to Azure"
#Checking to see if we are logged into Azure
echo "    Checking if we are logged in to Azure."
#We need to redirect the output streams to stdout
azstatus=`az group list 2>&1` 
if [[ $azstatus =~ "Please run 'az login' to setup account." ]]; then
   echo "   We need to login to azure.."
   az login
else
   echo "    Logged in."
fi
read -p "    Change default subscription? [y/n]:" changesubscription
if [[ $changesubscription =~ "y" ]];then
    read -p "      New Subscription Name:" newsubscription
    az account set --subscription "$newsubscription"
else
    echo "    Using default existing subscription."
fi

echo "GIT HUB REPO"
read -p "Download the GIT HUB repo for https://github.com/dansand71/AppDev-ContainerDemo? [y/n]" continuescript
if [[ $continuescript != "n" ]];then
    #Download the GIT Repo for keys etc.
    echo "--------------------------------------------"
    echo "Downloading the Github repo for the connectivity keys and bits."
    cd /source
    sudo rm -rf /source/AppDev-ContainerDemo
    sudo git clone https://github.com/dansand71/AppDev-ContainerDemo
    sudo chmod +x /source/AppDev-ContainerDemo/1-SetupDemo.sh
    echo ""
    echo "--------------------------------------------"
fi
if [ -f /source/appdev-demo-EnvironmentTemplateValues ];
  then
    echo "    Existing settings file found.  Not copying the version from /source/AppDev-ContainerDemo/vm-assets"
  else
    echo "    Copying the template file for your edits - /source/appdev-demo-EnvironmentTemplateValues"
    cp /source/AppDev-ContainerDemo/vm-assets/DemoEnvironmentTemplateValues /source/appdev-demo-EnvironmentTemplateValues
fi
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
read -p "Continue? [y/n]" continuescript
if [[ $continuescript != "y" ]];then
    exit
fi

#Leverage the existing public key for new VM creation script
echo "--------------------------------------------"
echo "Reading ~/.ssh/id_rsa.pub and writing values to /source/AppDev-ContainerDemo/*"
sshpubkey=$(< ~/.ssh/id_rsa.pub)
echo "Using public key:" ${sshpubkey}
sudo grep -rl REPLACE-SSH-KEY /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh | sudo xargs sed -i -e "s#REPLACE-SSH-KEY#$sshpubkey#g" 
echo "--------------------------------------------"

echo "Configure demo scripts"
sudo echo "export ANSIBLE_HOST_KEY_CHECKING=false" >> ~/.bashrc
export ANSIBLE_HOST_KEY_CHECKING=false
sudo grep -rl VALUEOF-UNIQUE-SERVER-PREFIX /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh  | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-SERVER-PREFIX@$DEMO_UNIQUE_SERVER_PREFIX@g"
sudo grep -rl VALUEOF-UNIQUE-STORAGE-ACCOUNT /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh  | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-STORAGE-ACCOUNT@$DEMO_STORAGE_ACCOUNT@g" 
sudo grep -rl VALUEOF-REGISTRY-SERVER-NAME /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh  | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-SERVER-NAME@$DEMO_REGISTRY_SERVER_NAME@g" 
sudo grep -rl VALUEOF-REGISTRY-USER-NAME /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh  | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-USER-NAME@$DEMO_REGISTRY_USER_NAME@g" 
sudo grep -rl VALUEOF-REGISTRY-PASSWORD /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh  | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-PASSWORD@$DEMO_REGISTRY_PASSWORD@g" 
sudo grep -rl VALUEOF-REPLACE-OMS-WORKSPACE /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh  | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-WORKSPACE@$DEMO_OMS_WORKSPACE@g" 
sudo grep -rl VALUEOF-REPLACE-OMS-PRIMARYKEY /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh  | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-PRIMARYKEY@$DEMO_OMS_PRIMARYKEY@g" 
sudo grep -rl VALUEOF-APPLICATION-INSIGHTS-KEY /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh  | sudo xargs sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-KEY@$DEMO_APPLICATION_INSIGHTS_KEY@g"

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
    az group create --name ossdemo-appdev-iaas --location eastus
    az group create --name ossdemo-appdev-acs --location eastus
    az group create --name ossdemo-appdev-paas --location eastus

    #BUILD NETWORKS SECURTIY GROUPS and RULES
    echo ""
    echo "BUILDING NETWORKS SECURTIY GROUPS and RULES"
    echo "--------------------------------------------"
    echo 'Network Security Groups (NSGs) for Resource Groups'
    az network nsg create --resource-group ossdemo-appdev-iaas --name NSG-ossdemo-appdev-iaas --location eastus
    az network nsg create --resource-group ossdemo-appdev-acs --name NSG-ossdemo-appdev-acs --location eastus
    az network nsg create --resource-group ossdemo-appdev-paas --name NSG-ossdemo-appdev-paas --location eastus

    echo 'Allow SSH inbound to iaas, acs and paas resource groups'
    az network nsg rule create --resource-group ossdemo-appdev-iaas \
        --nsg-name NSG-ossdemo-appdev-iaas --name ssh-rule \
        --access Allow --protocol Tcp --direction Inbound --priority 110 \
        --source-address-prefix Internet \
        --source-port-range "*" --destination-address-prefix "*" \
        --destination-port-range 22
    az network nsg rule create --resource-group ossdemo-appdev-iaas \
        --nsg-name NSG-ossdemo-appdev-iaas --name ssh-rule \
        --access Allow --protocol Tcp --direction Inbound --priority 120 \
        --source-address-prefix Internet \
        --source-port-range "*" --destination-address-prefix "*" \
        --destination-port-range 80

    az network nsg rule create --resource-group ossdemo-appdev-acs \
     --nsg-name NSG-ossdemo-appdev-acs --name ssh-rule \
     --access Allow --protocol Tcp --direction Inbound --priority 110 \
     --source-address-prefix Internet \
     --source-port-range "*" --destination-address-prefix "*" \
     --destination-port-range 22
     

    az network nsg rule create --resource-group ossdemo-appdev-paas \
     --nsg-name NSG-ossdemo-appdev-paas --name ssh-rule \
     --access Allow --protocol Tcp --direction Inbound --priority 110 \
     --source-address-prefix Internet \
     --source-port-range "*" --destination-address-prefix "*" \
     --destination-port-range 22
    az network nsg rule create --resource-group ossdemo-appdev-paas \
     --nsg-name NSG-ossdemo-appdev-paas --name ssh-rule \
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


#Set Scripts as executable
sudo chmod +x /source/AppDev-ContainerDemo/kubernetes/configK8S.sh
sudo chmod +x /source/AppDev-ContainerDemo/kubernetes/refreshK8S.sh
sudo chmod +x /source/AppDev-ContainerDemo/kubernetes/deploy.sh

sudo chmod +x /source/AppDev-ContainerDemo/azscripts/newVM.sh
sudo chmod +x /source/AppDev-ContainerDemo/azscripts/createAzureRegistry.sh
sudo chmod +x /source/AppDev-ContainerDemo/azscripts/createK8S-cluster.sh

##Please ensure your logged in to azure via the CLI & your subscription is set correctly

#Create new worker VM's for the docker demo
/source/AppDev-ContainerDemo/azscripts/newVM.sh

#Create Azure Registry
/source/AppDev-ContainerDemo/azscripts/createAzureRegistry.sh

#Create K8S Cluster
/source/AppDev-ContainerDemo/azscripts/createK8S-cluster.sh