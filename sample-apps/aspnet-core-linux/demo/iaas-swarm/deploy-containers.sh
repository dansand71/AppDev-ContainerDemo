#Build the containers.  This will build and tag them correctly
echo "Building the docker contaienrs using the docker-stack.yml file"
echo "  running command - docker-compose -f docker-stack.yml build"
docker-compose -f docker-stack.yml build
echo "-------------------------------------------------------------"

#PUSH containers up to private registry
echo "Pushing the containers up to the private registgry"
echo "  logging into docker azure registry"
echo "  running command - docker login VALUEOF-REGISTRY-SERVER-NAME -u VALUEOF-REGISTRY-USER-NAME -p VALUEOF-REGISTRY-PASSWORD"
# docker login VALUEOF-REGISTRY-SERVER-NAME -u VALUEOF-REGISTRY-USER-NAME -p VALUEOF-REGISTRY-PASSWORD
echo "-------------------------------------------------------------"
echo "  pushing into docker azure registry"
echo "  running command - docker push VALUEOF-REGISTRY-SERVER-NAME/gbbossdemo/aspnet-core-linux"
# docker push VALUEOF-REGISTRY-SERVER-NAME/gbbossdemo/aspnet-core-linux
echo "-------------------------------------------------------------"
# we need to update the docker-stack.yml file to reference the "VALUEOF-REGISTRY-SERVER-NAME/gbbossdemo/aspnet-core-linux" image
# there is some sort of command to pass the credentials for the login to the nodes on the stack deploy command line

#We should try and remove any existing version of the running application deployed to the SWARM
echo "  Removing any existing instances of aspnet_web that might already be deployed."
echo "  running command - docker service rm aspnet_web"
docker service rm aspnet_web

#Deploy containers to SWARM
echo "  Deploying the stack using the yml file"
echo "  running command - docker stack deploy --compose-file docker-stack.yml aspnet"
docker stack deploy --compose-file docker-stack.yml aspnet
