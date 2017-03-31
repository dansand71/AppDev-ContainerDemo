
projectList=(
    "../../src/Services/Catalog/Catalog.API"
    "../../src/Services/Basket/Basket.API"
    "../../src/Services/Ordering/Ordering.API"
    "../../src/Services/Identity/Identity.API"
    "../../src/Web/WebMVC"
    # "../src/Web/WebSPA"
)

# Build SPA app
#pushd $(pwd)/src/Web/WebSPA
#npm rebuild node-sass
#npm run build:prod

for project in "${projectList[@]}"
do
    echo -e "\e[33mWorking on $(pwd)/$project"
    echo -e "\e[33m\tRemoving old publish output"
    pushd $(pwd)/$project
    sudo rm -rf obj/Docker/publish
    echo -e "\e[33m\tRestoring project"
    /usr/local/bin/dotnet restore
    echo -e "\e[33m\tBuilding and publishing projects"
    /usr/local/bin/dotnet publish -o obj/Docker/publish
    popd
done

# remove old docker images:
echo ""
echo "Remove any existing eShop docker images on the build box...."
images=$(sudo docker images --filter=reference="eshop/*" -q)
if [ -n "$images" ]; then
    sudo docker rm $(sudo docker ps -a -q) -f
    echo "Deleting eShop images in local Docker repo"
    echo $images
    sudo docker rmi $(sudo docker images --filter=reference="eshop/*" -q) -f
fi

# No need to build the images, docker build or docker compose will
# do that using the images and containers defined in the docker-compose.yml file.
echo ""
echo "-------------------------------------"
echo "Build complete"
echo "-------------------------------------"
read -p "Test Docker Images and run COMPOSE UP locally? [y/n]:"  continuescript
#This environment requires accurate settings of HOST NAME in  .env file off the source directory.  Change for BUILD BOX....
if [[ $continuescript != "n" ]];then
    #we need to ensure .env is accurate
    #UID for login is demouser@microsoft.com - Paas@word1
    read -p "Test Docker Images and run COMPOSE UP locally? [y/n]:"  editfile
    #This environment requires accurate settings of HOST NAME in  .env file off the source directory.  Change for BUILD BOX....
    if [[ $editfile != "n" ]];then
       gedit /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/.env    
    fi
    echo " running command: sudo /usr/local/bin/docker-compose -f /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/docker-compose.yml -f /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/docker-compose.prod.yml up"    
    sudo /usr/local/bin/docker-compose -f /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/docker-compose.yml -f /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/docker-compose.prod.yml up
fi