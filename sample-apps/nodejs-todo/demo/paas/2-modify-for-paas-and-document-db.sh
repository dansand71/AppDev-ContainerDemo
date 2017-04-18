#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

#az account set --subscription "Microsoft Azure Internal Consumption"
echo -e "${BOLD}Create Document DB?...${RESET}"
read -p "$(echo -e -n "${INPUT}Create new DocumentDB resource into ossdemo-utility resource group? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    ~/bin/az group deployment create --resource-group ossdemo-utility --name DocumentDB-Deployment \
        --template-file /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/environment/ossdemo-utility-documentdb.json                    
fi
echo "-------------------------"
echo "Modify /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/database.js for remote documentDB"
#Change connection string in code - we can also move this to an ENV variable instead
DOCUMENTDBKEY=~/bin/az documentdb list-connection-strings -g ossdemo-utility -n VALUEOF-UNIQUE-SERVER-PREFIX-documentdb --query connectionStrings[].connectionString -o tsv
sed -i -e "s@mongodb://nosqlsvc:27017/todo@mongodb://${DOCUMENTDBKEY}/todo@g" /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/database.js


echo -e "${BOLD}Create Nodejs app service?...${RESET}"
read -p "$(echo -e -n "${INPUT}Create new Azure App Service for node.js application resource into ossdemo-appdev-paas resource group? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    #command to create app service
fi

echo "-------------------------"
echo -e "${BOLD}Publish Nodejs to Azure app service?...${RESET}"
read -p "$(echo -e -n "${INPUT}Publish up the nodejs application to Azure App service? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    ## Create the plan - only available in West US for now - Already done via template
    echo ".creating appservice web plan"
    ~/bin/az appservice plan create -g ossdemo-appdev-paas -n webtier-plan --is-linux --number-of-workers 1 --sku S1 -l westus

    echo ".creating appservice web app"
    ## Create the appservice - Already done via template
    ~/bin/az appservice web create -g ossdemo-appdev-paas -p webtier-plan -n VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo

    echo ".updating the web app with the nodejs details"
    ## Config the Docker Container
    ~/bin/az appservice web config update --linux-fx-version "NODE|6.9.3" --startup-file process.json --name VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo --resource-group ossdemo-appdev-paas

    echo ".configuring for git deployment"
    while true
        do
        read -s -p "$(echo -e -n "${INPUT}.Git Deployment Password for app:${RESET}")" jumpboxPassword
        echo ""
        read -s -p "$(echo -e -n "${INPUT}.Re-enter to verify:${RESET}")" jumpboxPassword2
        
        if [ $jumpboxPassword = $jumpboxPassword2 ]
        then
            break 2
        else
            echo -e ".${RED}Passwords do not match.  Please retry. ${RESET}"
        fi
    done
    echo ".setting remote deployment user and password for VALUEOF-DEMO-ADMIN-USER-NAME"  #This is pulled from the initial demo environment setup
    ~/bin/az appservice web deployment user set --user-name VALUEOF-DEMO-ADMIN-USER-NAME --password $jumpboxPassword
    GITURL=~/bin/az appservice web source-control config-local-git --name VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo --resource-group ossdemo-appdev-paas --query url --output tsv
    echo ".git url is: ${GITURL}"
    echo ".add git url to local repo"
    git remote add nodejs-todo-azure-appsvc $GITURL
    echo ".now push to azure"
    cd /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src
    git push nodejs-todo-azure-appsvc master

fi



#publish to the app service
