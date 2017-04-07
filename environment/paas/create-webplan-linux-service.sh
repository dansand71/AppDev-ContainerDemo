## Create the plan - only available in West US for now - Already done via template
~/bin/az appservice plan create -g ossdemo-appdev-paas -n webtier-plan --is-linux --number-of-workers 1 --sku S1 -l westus

## Create the appservice - Already done via template
~/bin/az appservice web create -g ossdemo-appdev-paas -p webtier-plan -n VALUEOF-UNIQUE-SERVER-PREFIX-aspnet-core-linux-paas