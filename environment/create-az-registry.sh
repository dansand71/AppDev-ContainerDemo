#Read in the demo default template values and crate a new registry with that name and a new storage account

source /source/appdev-demo-EnvironmentTemplateValues
echo ""
echo "Creating AZ Registry ${DEMO_UNIQUE_SERVER_PREFIX}demoregistry.  Current Template Values:"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX
echo "      
echo ""

az acr create -n ${DEMO_UNIQUE_SERVER_PREFIX}demoregistry -g ossdemo-utility -l eastus --admin-enabled true --sku Basic

