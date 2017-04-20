#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"


sourcedir="/source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/src"
projectList=(
    "${sourcedir}/src/Services/Catalog/Catalog.API"
    "${sourcedir}/src/Services/Basket/Basket.API"
    "${sourcedir}/src/Services/Ordering/Ordering.API"
    "${sourcedir}/src/Services/Identity/Identity.API"
    "${sourcedir}/src/Web/WebMVC"
    # "../src/Web/WebSPA"
)
echo -e ".checking to see if we have already cloned the sample from GITHUB"
if [ "$(ls -A /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/src)" ]; then
     echo ".files already downloaded, no action needed."
else
    echo ".running initial setup of repo for sample."
    ../../1-setup-demo.sh
fi
# Build SPA app
#pushd $(pwd)/src/Web/WebSPA
#npm rebuild node-sass
#npm run build:prod
echo -e "${BOLD}Compile source code${RESET}"
read -p "Build bits? [Y/n]:"  continuescript
#This environment requires accurate settings of HOST NAME in  .env file off the source directory.  Change for BUILD BOX....
if [[ ${continuescript,,} != "n" ]];then
for project in "${projectList[@]}"
do
    echo -e "${BOLD}Working on $project ${RESET}"
    echo -e "${YELLOW}Removing old publish output${RESET}"
    pushd $project
    sudo rm -rf obj/Docker/publish
    echo -e "Restoring project"
    /usr/local/bin/dotnet restore
    echo -e "Building and publishing projects"
    /usr/local/bin/dotnet publish -o obj/Docker/publish
    echo -e "Building and publishing projects"
    popd
done
fi
echo -e "${BOLD}Docker Images${RESET}"
read -p "Remove old images & rebuild? [Y/n]:"  continuescript
if [[ ${continuescript,,} != "n" ]];then
    # remove old docker images:
    echo ""
    echo "Remove existing eShop docker images on the build box...."
    images=$(sudo docker images --filter=reference="eshop/*" -q)
    if [ -n "$images" ]; then
        echo ".removing images"
        echo $images
        sudo docker rmi $(sudo docker images --filter=reference="eshop/*" -q) -f
    fi
    echo "Remove existing VALUEOF-REGISTRY-SERVER-NAME/eshop docker images on the build box...."
    images=$(sudo docker images --filter=reference="VALUEOF-REGISTRY-SERVER-NAME/eshop/*" -q)
    if [ -n "$images" ]; then
        echo ".removing images"
        echo $images
        sudo docker rmi $(sudo docker images --filter=reference="VALUEOF-REGISTRY-SERVER-NAME/eshop/*" -q) -f
    fi
    echo ".running command: sudo /usr/local/bin/docker-compose -f docker-compose.yml -f docker-compose.dev.yml build"    
    sudo docker-compose -f docker-stack.yml build
fi

# No need to build the images, docker build or docker compose will
# do that using the images and containers defined in the docker-compose.yml file.
echo ""
echo "-------------------------------------"
echo "${BOLD}Push to Registry${RESET}"
echo "-------------------------------------"
read -p "Push eshop images to registry? [Y/n]:"  continuescript
#This environment requires accurate settings of HOST NAME in  .env file off the source directory.  Change for BUILD BOX....
if [[ $continuescript != "n" ]];then
    #we need to ensure .env is accurate
    #UID for login is demouser@microsoft.com - Paas@word1
    #read -p "EDIT the .env file so you can run this locally?  You will replace the hostname with jumpbox-YOUR-SERVER-PREFIX.eastus.cloudapp.azure.com [y/n]:"  editfile
    #This environment requires accurate settings of HOST NAME in  .env file off the source directory.  Change for BUILD BOX....
    #if [[ $editfile != "n" ]];then
    #   gedit /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/.env    
    #fi
    
    echo ".logging into Azure Docker Registry"
    sudo docker login VALUEOF-REGISTRY-SERVER-NAME -u VALUEOF-REGISTRY-USER-NAME -p VALUEOF-REGISTRY-PASSWORD
    images=$(sudo docker images --filter=reference="VALUEOF-REGISTRY-SERVER-NAME/eshop/*" -q)
    if [ -n "$images" ]; then
        sudo docker images --filter=reference="VALUEOF-REGISTRY-SERVER-NAME/eshop/*" -q | while read IMAGE_ID; 
            do 
                IMAGENAME=$(sudo docker inspect -format='{{.RepoTags}}' --type=image ${IMAGE_ID} | sed "s/ormat=\[//" | sed "s/:latest\]//")
                echo "-------------------------------"
                echo ".working with:${IMAGENAME} image"
                #echo ".tagging ${IMAGENAME}"
                #sudo docker tag $IMAGENAME VALUEOF-REGISTRY-SERVER-NAME/$IMAGENAME
                echo ".pushing ${IMAGENAME} to VALUEOF-REGISTRY-SERVER-NAME"
                sudo docker push $IMAGENAME;
            done
    fi
fi
echo "-------------------------------------"
echo -e "${BOLD}Deploy to Docker SWARM${RESET}"
read -p "Deploy to Docker SWARM? [Y/n]:"  continuescript
#This environment requires accurate settings of HOST NAME in  .env file off the source directory.  Change for BUILD BOX....
if [[ $continuescript != "n" ]];then
    echo ".removing any existing SWARM services for eshop"
    sudo docker stack rm eshop
    echo ".logging into the docker registry"    
    sudo docker login VALUEOF-REGISTRY-SERVER-NAME -u VALUEOF-REGISTRY-USER-NAME -p VALUEOF-REGISTRY-PASSWORD
    echo ".running command: sudo docker stack deploy --compose-file docker-stack.yml eshop"
    sudo docker stack deploy --compose-file docker-stack.yml --with-registry-auth eshop 
fi

echo "--------------------------------------"
echo "Warming up .net cache"
curl -s http://VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo.eastus.cloudapp.azure.com:5100/
curl -s http://VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo.eastus.cloudapp.azure.com:5101/
curl -s http://VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo.eastus.cloudapp.azure.com:5102/
curl -s http://VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo.eastus.cloudapp.azure.com:5103/
#curl -s http://VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo.eastus.cloudapp.azure.com:5104/
curl -s http://VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo.eastus.cloudapp.azure.com:5105/

echo "--------------------------------------"
echo "Site is up at: http://VALUEOF-UNIQUE-SERVER-PREFIX-iaas-demo.eastus.cloudapp.azure.com:5100/"
echo "If this is your first time running the SQL Databases will need to be configured."
echo "Login as demouser@microsoft.com  password=Pass@word1 to add items to the cart."
echo "--------------------------------------"
echo "Example of scaling services:"
echo "sudo docker service scale eshop_orderingapi=1"
echo "sudo docker service scale eshop_webmvc=5"
echo "sudo docker service scale eshop_basketapi=1"
echo "sudo docker service scale eshop_catalogapi=2"