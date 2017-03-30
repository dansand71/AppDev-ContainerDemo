## Create the plan
az appservice plan create -g ossdemo-appdev-paas -n webtier-plan --is-linux --number-of-workers 1 --sku S1

## Create the appservice
az appservice web create -g ossdemo-appdev-paas -p webtier-plan -n aspnet-core-linux-paas

## Config the Docker Container
az appservice web config container update -n aspnet-core-linux-paas  \
    --docker-registry-password VALUEOF-REGISTRY-PASSWORD \
    --docker-registry-user VALUEOF-REGISTRY-USER-NAME \
    --docker-registry-url VALUEOF-REGISTRY-SERVER-NAME \
    --docker-custom-image-name VALUEOF-REGISTRY-SERVER-NAME/gbbossdemo/aspnet-core-linux

