## Create the plan - only available in West US for now - Already done via template
echo ".creating appservice web plan"
~/bin/az appservice plan create -g ossdemo-appdev-paas -n webtier-plan --is-linux --number-of-workers 1 --sku S1 -l westus

echo ".creating appservice web app"
## Create the appservice - Already done via template
~/bin/az webapp create -g ossdemo-appdev-paas -p webtier-plan -n VALUEOF-UNIQUE-SERVER-PREFIX-aspnet-core-linux-paas

echo ".updating the web app with the container details"
## Config the Docker Container
~/bin/az webapp config container set -n VALUEOF-UNIQUE-SERVER-PREFIX-aspnet-core-linux-paas -g ossdemo-appdev-paas \
    --docker-registry-server-password VALUEOF-REGISTRY-PASSWORD \
    --docker-registry-server-user VALUEOF-REGISTRY-USER-NAME \
    --docker-registry-server-url VALUEOF-REGISTRY-SERVER-NAME \
    --docker-custom-image-name VALUEOF-REGISTRY-SERVER-NAME/ossdemo/aspnet-core-linux

