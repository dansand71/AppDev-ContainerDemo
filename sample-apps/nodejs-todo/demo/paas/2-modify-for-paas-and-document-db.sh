#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

#az account set --subscription "Microsoft Azure Internal Consumption"
echo "-------------------------"
echo -e "${BOLD}Checking to see if we need to download the sample app...${RESET}"
mkdir /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src
if [ "$(ls -A /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src)" ]; then
     echo ".files already downloaded, no action needed."
else
    echo ".source directory is empty.  cloning from github."
    cd /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src
    git clone https://github.com/dansand71/node-todo .
fi
echo "Modify /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/database.js for remote documentDB"
#Change connection string in code - we can also move this to an ENV variable instead
DOCUMENTDBKEY=`~/bin/az documentdb list-connection-strings -g ossdemo-appdev-paas -n VALUEOF-UNIQUE-SERVER-PREFIX-documentdb --query connectionStrings[].connectionString -o tsv`
sed -i -e "s|mongodb://nosqlsvc:27017/todo|$DOCUMENTDBKEY|g" /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/paas/deploy-nodejs.yml


#BUILD Container & publish to registry
read -p "$(echo -e -n "${INPUT}Create and publish containers into Azure Private Registry? [Y/n]:"${RESET})" continuescript
if [[ ${continuescript,,} != "n" ]]; then
    /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/demo/ansible/build-containers.sh
fi

echo ".updating the web app with the container details"
## Config the Docker Container
~/bin/az appservice web config container update -n VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo -g ossdemo-appdev-paas \
    --docker-registry-server-password VALUEOF-REGISTRY-PASSWORD \
    --docker-registry-server-user VALUEOF-REGISTRY-USER-NAME \
    --docker-registry-server-url VALUEOF-REGISTRY-SERVER-NAME \
    --docker-custom-image-name VALUEOF-REGISTRY-SERVER-NAME/ossdemo/nodejs-todo-docdb

#Set the port to 8080 - this is in the DockerFile
echo ".updating the port settings on the website...."
~/bin/az appservice web config appsettings update -n VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo -g ossdemo-appdev-paas --setting PORT=8081
~/bin/az appservice web config appsettings update -n VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo -g ossdemo-appdev-paas --setting MONGO_DBCONNECTION=${DOCUMENTDBKEY}

echo ".container file updated.  Please see portal for additional details."
echo ".testing url http://VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo.azurewebsites.net"

# echo -e "${BOLD}Pushing code to app service...${RESET}"

# echo ".attempting to push code to azure"
# Config the nodejs environment
#~/bin/az appservice web config update --linux-fx-version "NODE|6.9.3" --startup-file package.json --name VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo --resource-group ossdemo-appdev-paas
# cd /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src
# #this tag was created in the initial demo setup ../1-setup-demo.sh
# #commit changes to the database.js and server.js files
# git config --global user.name "Demo user"
# git config --global user.email "gbossdemo@yourcompany.com"
# git commit -m "changed based on demo environment" -a
# git push nodejs-todo-azure-appsvc master
