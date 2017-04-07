## Create the plan - only available in West US for now - Already done via template
echo ".creating appservice web plan"
~/bin/az appservice plan create -g ossdemo-appdev-paas -n webtier-plan --is-linux --number-of-workers 1 --sku S1 -l westus

echo ".creating appservice web app"
## Create the appservice - Already done via template
~/bin/az appservice web create -g ossdemo-appdev-paas -p webtier-plan -n VALUEOF-UNIQUE-SERVER-PREFIX-aspnet-core-linux-paas

echo ".updating the web app with the container details"
## Config the Docker Container
~/bin/az appservice web config container update -n dsand71-aspnet-core-linux-paas -g ossdemo-appdev-paas \
    --docker-registry-server-password +DMd=zRH+i+LnW0m173F=9vFq54ngWPs \
    --docker-registry-server-user dsand71demoregistry \
    --docker-registry-server-url dsand71demoregistry.azurecr.io \
    --docker-custom-image-name dsand71demoregistry.azurecr.io/ossdemo/aspnet-core-linux
