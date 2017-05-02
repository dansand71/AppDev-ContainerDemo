echo "Create ansible account on jumpbox"
useradd ansible
echo "completing pre-reqs for Ansible Azure Integration"
pip install --upgrade pip
pip install enum
su - ansible
mkdir $HOME/.azure

echo "Creating random password"
secret=date | md5sum
echo ".delete az ad sp if it exists for http://ossdemo-ansible-VALUEOF-UNIQUE-SERVER-PREFIX"
az ad sp delete --id http://ossdemo-ansible-VALUEOF-UNIQUE-SERVER-PREFIX
echo ".create az ad sp for ossdemo-ansible-VALUEOF-UNIQUE-SERVER-PREFIX"
az ad sp create-for-rbac --name ossdemo-ansible-VALUEOF-UNIQUE-SERVER-PREFIX --password $secret

#Show details
echo ".show - az ad sp show --id http://ossdemo-oshiftorigin-VALUEOF-UNIQUE-SERVER-PREFIX"
az ad sp show --id http://ossdemo-oshiftorigin-VALUEOF-UNIQUE-SERVER-PREFIX
#create az ad app for oshift
#az ad app create --display-name ossdemo-oshiftorigin-dansand --homepage https://dansand-ossdemo-oshift-masterpip.eastus.cloudapp.azure.com:8443/console --reply-urls https://dansand-ossdemo-oshift-masterpip.eastus.cloudapp.azure.com:8443/oauth2callback/ossdemo-oshiftorigin-dansand --identifier-uris http://ossdemo-oshiftorigin-dansand2

echo ".creating ansible credentials and saving them in $HOME/.azure/credentials"
clientID=`az ad sp show --id http://ossdemo-ansible-dansand --query appId -o tsv`
tenantID=`az account show --query tenantId -o tsv`
subscriptionID=`az account show --query id -o tsv`
sshKeyData=$(< $HOME/.ssh/id_rsa.pub)

#directory used for ansible credentials

echo "[default]" > $HOME/.azure/credentials
echo "subscription_id=${subscriptionID}" >> $HOME/.azure/credentials
echo "tenant=${tenantID}" >> $HOME/.azure/credentials
echo "client_id=${clientID}" >> $HOME/.azure/credentials
echo "secret=${secret}" >> $HOME/.azure/credentials

echo "Complete"