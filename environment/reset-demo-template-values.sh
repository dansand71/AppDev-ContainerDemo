source /source/appdev-demo-EnvironmentTemplateValues

#SET SUBSCRIPTIONID from LOGIN to TEMPLATES
AZSUB=`~/bin/az account show | jq '.id'`
AZSUB=("${AZSUB[@]//\"/}")
echo "Working with SubscriptionID:" $AZSUB

EXCLUDEFILE="*reset-demo-template-values.sh"
echo "Excluding file:" $EXCLUDEFILE

echo ".Editing SUBSCRIPTIONID"
sudo grep -q -rl REPLACE-JSON-SUBSCRIPTIONID . --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@REPLACE-JSON-SUBSCRIPTIONID@$AZSUB@g"

echo ".Editing SERVER PREFIX"
sudo grep -q -rl VALUEOF-UNIQUE-SERVER-PREFIX . --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-SERVER-PREFIX@${DEMO_UNIQUE_SERVER_PREFIX,,}@g"

echo ".Editing DEMO ADMIN USER NAME"
sudo grep -q -rl VALUEOF-DEMO-ADMIN-USER-NAME . --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-DEMO-ADMIN-USER-NAME@${DEMO_ADMIN_USER,,}@g"

echo ".Editing STORAGE ACCOUNT"
sudo grep -q -rl VALUEOF-UNIQUE-STORAGE-ACCOUNT . --exclude=$EXCLUDEFILE | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-STORAGE-ACCOUNT@$DEMO_STORAGE_ACCOUNT@g" 

echo ".Editing REGISTRY SERVER NAME"
sudo grep -q -rl VALUEOF-REGISTRY-SERVER-NAME . --exclude=$EXCLUDEFILE   | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-SERVER-NAME@$DEMO_REGISTRY_SERVER_NAME@g" 

echo ".Editing REGISTRY USER NAME"
sudo grep -q -rl VALUEOF-REGISTRY-USER-NAME . --exclude=$EXCLUDEFILE     | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-USER-NAME@$DEMO_REGISTRY_USER_NAME@g" 

echo ".Editing REGISTRY PASSWORD"
sudo grep -q -rl VALUEOF-REGISTRY-PASSWORD . --exclude=$EXCLUDEFILE      | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-PASSWORD@$DEMO_REGISTRY_PASSWORD@g" 

echo ".Editing OMS WORKSPACE"
sudo grep -q -rl VALUEOF-REPLACE-OMS-WORKSPACE . --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-WORKSPACE@$DEMO_OMS_WORKSPACE@g" 

echo ".Editing OMS PRIMARY KEY"
sudo grep -q -rl VALUEOF-REPLACE-OMS-PRIMARYKEY . --exclude=$EXCLUDEFILE | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-PRIMARYKEY@$DEMO_OMS_PRIMARYKEY@g" 

echo ".Editing APP INSIGHTS ESHOP DEMO"
sudo grep -q -rl VALUEOF-APPLICATION-INSIGHTS-ESHOPONCONTAINER-KEY . --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-ESHOPONCONTAINER-KEY@$DEMO_APPLICATION_INSIGHTS_ESHOPONCONTAINERS_KEY@g"

echo ".Editing APP INSIGHTS ASPNETCORE DEMO"
sudo grep -q -rl VALUEOF-APPLICATION-INSIGHTS-ASPNETCORELINUX-KEY . --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-ASPNETCORELINUX-KEY@$DEMO_APPLICATION_INSIGHTS_ASPNETLINUX_KEY@g"

#Leverage the existing public key for new VM creation script
sshpubkey=$(< ~/.ssh/id_rsa.pub)
sudo grep -q -rl REPLACE-SSH-KEY /source --exclude=$EXCLUDEFILE | sudo xargs sed -i -e "s#REPLACE-SSH-KEY#$sshpubkey#g" 
