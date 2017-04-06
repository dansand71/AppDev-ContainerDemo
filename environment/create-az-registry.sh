#Read in the demo default template values and crate a new registry with that name and a new storage account

source /source/appdev-demo-EnvironmentTemplateValues
echo ""
echo "Current Template Values:"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX
echo "      DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
echo ""

az acr create -n ${DEMO_UNIQUE_SERVER_PREFIX}registry -g ossdemo-utility -l eastus --admin-enabled true --sku basic

#Create success - now read from AZ and get the SERVER, USER and PASSWORD VALUES
REGISTRYSERVER=""
REGISTRYUSER=""
REGISTRYPASSWORD=""

#populate the TEMPLATE FILE with these values
sudo sudo sed -i -e "s@DEMO_REGISTRY_SERVER_NAME=""@DEMO_REGISTRY_SERVER_NAME="$REGISTRYSERVER"@g" /source/appdev-demo-EnvironmentTemplateValues
sudo sudo sed -i -e "s@DEMO_REGISTRY_USER_NAME=""@DEMO_REGISTRY_SERVER_NAME="$REGISTRYUSER"@g" /source/appdev-demo-EnvironmentTemplateValues
sudo sudo sed -i -e "s@DEMO_REGISTRY_PASSWORD=""@DEMO_REGISTRY_SERVER_NAME="$REGISTRYPASSWORD"@g" /source/appdev-demo-EnvironmentTemplateValues
