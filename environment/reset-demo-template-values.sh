source /source/appdev-demo-EnvironmentTemplateValues

#SET SUBSCRIPTIONID from LOGIN to TEMPLATES
AZJSONSUBSRIPTIONID=`~/bin/az account show | jq '.id'`
echo "Working with SubscriptionID:" $AZJSONSUBSRIPTIONID
cd /source/AppDev-ContainerDemo

EXCLUDEFILE="*reset-demo-template-values.sh"
echo "Excluding file:" $EXCLUDEFILE

echo ".Editing SUBSCRIPTIONID"
sudo grep -rl REPLACE-JSON-SUBSCRIPTIONID /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@REPLACE-JSON-SUBSCRIPTIONID@$AZJSONSUBSRIPTIONID@g"
echo ".Editing SERVER PREFIX"
sudo grep -rl VALUEOF-UNIQUE-SERVER-PREFIX /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-SERVER-PREFIX@$DEMO_UNIQUE_SERVER_PREFIX@g"
echo ".Editing DEMO ADMIN USER NAME"
sudo grep -rl VALUEOF-DEMO-ADMIN-USER-NAME /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-DEMO-ADMIN-USER-NAME@$DEMO_ADMIN_USER@g"
echo ".Editing STORAGE ACCOUNT"
sudo grep -rl VALUEOF-UNIQUE-STORAGE-ACCOUNT /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-STORAGE-ACCOUNT@$DEMO_STORAGE_ACCOUNT@g" 
echo ".Editing REGISTRY SERVER NAME"
sudo grep -rl VALUEOF-REGISTRY-SERVER-NAME /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE   | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-SERVER-NAME@$DEMO_REGISTRY_SERVER_NAME@g" 
echo ".Editing REGISTRY USER NAME"
sudo grep -rl VALUEOF-REGISTRY-USER-NAME /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE     | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-USER-NAME@$DEMO_REGISTRY_USER_NAME@g" 
echo ".Editing REGISTRY PASSWORD"
sudo grep -rl VALUEOF-REGISTRY-PASSWORD /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE      | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-PASSWORD@$DEMO_REGISTRY_PASSWORD@g" 
echo ".Editing OMS WORKSPACE"
sudo grep -rl VALUEOF-REPLACE-OMS-WORKSPACE /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-WORKSPACE@$DEMO_OMS_WORKSPACE@g" 
echo ".Editing OMS PRIMARY KEY"
sudo grep -rl VALUEOF-REPLACE-OMS-PRIMARYKEY /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-PRIMARYKEY@$DEMO_OMS_PRIMARYKEY@g" 
echo ".Editing APP INSIGHTS ESHOP DEMO"
sudo grep -rl VALUEOF-APPLICATION-INSIGHTS-ESHOPONCONTAINER-KEY /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-ESHOPONCONTAINER-KEY@$DEMO_APPLICATION_INSIGHTS_ESHOPONCONTAINERS_KEY@g"
echo ".Editing APP INSIGHTS ASPNETCORE DEMO"
sudo grep -rl VALUEOF-APPLICATION-INSIGHTS-ASPNETCORELINUX-KEY /source/AppDev-ContainerDemo --exclude=$EXCLUDEFILE  | sudo xargs sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-ASPNETCORELINUX-KEY@$DEMO_APPLICATION_INSIGHTS_ASPNETLINUX_KEY@g"

cd /source