source /source/appdev-demo-EnvironmentTemplateValues

#SET SUBSCRIPTIONID from LOGIN to TEMPLATES
AZJSONSUBSRIPTIONID=`~/bin/az account show | jq '.id'`
cd /source/AppDev-ContainerDemo

sudo grep -rl @REPLACE-JSON-SUBSCRIPTIONID /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@REPLACE-JSON-SUBSCRIPTIONID@$AZJSONSUBSCRIPTIONID@g"

sudo grep -rl VALUEOF-UNIQUE-SERVER-PREFIX /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-SERVER-PREFIX@$DEMO_UNIQUE_SERVER_PREFIX@g"

sudo grep -rl VALUEOF-UNIQUE-SERVER-PREFIX /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-DEMO-ADMIN-USER-NAME@$DEMO_ADMIN_USER@g"

sudo grep -rl VALUEOF-UNIQUE-STORAGE-ACCOUNT /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-STORAGE-ACCOUNT@$DEMO_STORAGE_ACCOUNT@g" 

sudo grep -rl VALUEOF-REGISTRY-SERVER-NAME /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh   | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-SERVER-NAME@$DEMO_REGISTRY_SERVER_NAME@g" 

sudo grep -rl VALUEOF-REGISTRY-USER-NAME /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh     | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-USER-NAME@$DEMO_REGISTRY_USER_NAME@g" 

sudo grep -rl VALUEOF-REGISTRY-PASSWORD /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh      | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-PASSWORD@$DEMO_REGISTRY_PASSWORD@g" 

sudo grep -rl VALUEOF-REPLACE-OMS-WORKSPACE /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-WORKSPACE@$DEMO_OMS_WORKSPACE@g" 

sudo grep -rl VALUEOF-REPLACE-OMS-PRIMARYKEY /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-PRIMARYKEY@$DEMO_OMS_PRIMARYKEY@g" 

sudo grep -rl VALUEOF-APPLICATION-INSIGHTS-ESHOPONCONTAINER-KEY /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-ESHOPONCONTAINER-KEY@$DEMO_APPLICATION_INSIGHTS_ESHOPONCONTAINERS_KEY@g"

sudo grep -rl ALUEOF-APPLICATION-INSIGHTS-ASPNETCORELINUX-KEY /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-ASPNETCORELINUX-KEY@$DEMO_APPLICATION_INSIGHTS_ASPNETLINUX_KEY@g"

cd /source