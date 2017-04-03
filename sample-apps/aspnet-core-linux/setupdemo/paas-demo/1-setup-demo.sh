## Create the plan - only available in West US fo rnow
az appservice plan create -g ossdemo-appdev-paas -n webtier-plan --is-linux --number-of-workers 1 --sku S1 -l westus

## Create the appservice
az appservice web create -g ossdemo-appdev-paas -p webtier-plan -n VALUEOF-UNIQUE-SERVER-PREFIX-aspnet-core-linux-paas

## Config the Docker Container
az appservice web config container update -n VALUEOF-UNIQUE-SERVER-PREFIX-aspnet-core-linux-paas -g ossdemo-appdev-paas \
    --docker-registry-server-password VALUEOF-REGISTRY-PASSWORD \
    --docker-registry-server-user VALUEOF-REGISTRY-USER-NAME \
    --docker-registry-server-url VALUEOF-REGISTRY-SERVER-NAME \
    --docker-custom-image-name VALUEOF-REGISTRY-SERVER-NAME/gbbossdemo/aspnet-core-linux

## Config ARR so we round robin for demos
az appservice web config container update -n VALUEOF-UNIQUE-SERVER-PREFIX-aspnet-core-linux-paas -g ossdemo-appdev-paas \
    --docker-registry-server-password VALUEOF-REGISTRY-PASSWORD \
    --docker-registry-server-user VALUEOF-REGISTRY-USER-NAME \
    --docker-registry-server-url VALUEOF-REGISTRY-SERVER-NAME \
    --docker-custom-image-name VALUEOF-REGISTRY-SERVER-NAME/gbbossdemo/aspnet-core-linux

