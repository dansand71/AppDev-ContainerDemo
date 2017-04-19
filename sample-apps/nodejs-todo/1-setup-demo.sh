#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

echo -e "${BOLD}Create Document DB?...${RESET}"
read -p "$(echo -e -n "${INPUT}Create new DocumentDB resource into ossdemo-utility resource group? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    ~/bin/az documentdb create --name VALUEOF-UNIQUE-SERVER-PREFIX-documentdb --resource-group ossdemo-appdev-paas --kind MongoDB
fi
echo -e "${BOLD}Checking to see if we need to download the sample app...${RESET}"
mkdir /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src
if [ "$(ls -A /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src)" ]; then
     echo ".files already downloaded, no action needed."
else
    echo ".source directory is empty.  cloning from github."
    cd /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src
    git clone https://github.com/dansand71/node-todo .
fi

echo "-------------------------"
echo "Ensuring App Insights is configured for the sample"
    /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/environment/create-app-insight.sh
echo "-------------------------"

echo "-------------------------"
echo -e "${BOLD}Create App Service & web plan?...${RESET}"
read -p "$(echo -e -n "${INPUT}Create Azure App service plan and service? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    ## Create the plan - only available in West US for now - Already done via template
    echo ".creating appservice web plan"
    ~/bin/az appservice plan create -g ossdemo-appdev-paas -n webtier-plan --is-linux --number-of-workers 1 --sku S1 -l westus

    echo ".creating appservice web app"
    ## Create the appservice - Already done via template
    ~/bin/az appservice web create -g ossdemo-appdev-paas -p webtier-plan -n VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo

    echo ".updating the web app with the nodejs details"
    ## Config the nodejs environment
    ~/bin/az appservice web config update --linux-fx-version "NODE|6.9.3" --startup-file package.json --name VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo --resource-group ossdemo-appdev-paas
fi

echo -e "${BOLD}Configure for git deployment & push code?...${RESET}"
read -p "$(echo -e -n "${INPUT}Create Azure App service login and git URL? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then

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
    echo ""
    echo ".setting remote deployment user and password for VALUEOF-DEMO-ADMIN-USER-NAME"  #This is pulled from the initial demo environment setup
    ~/bin/az appservice web deployment user set --user-name VALUEOF-DEMO-ADMIN-USER-NAME --password $jumpboxPassword
    GITURL=`~/bin/az appservice web source-control config-local-git --name VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo --resource-group ossdemo-appdev-paas --query url --output tsv`
    echo ".git url is: ${GITURL}"
    echo ".add git url to local repo"
    cd /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src
    git remote add nodejs-todo-azure-appsvc $GITURL

fi