/source/AppDev-ContainerDemo/environment/iaas/create-swarm-cluster.sh

sudo docker stack deploy --compose-file visualizer.yml monitoring

#this is to show a temporary scenario that we store data from the linux container into a local directory on the jumpbox server
echo ".create sql data directory if it doesnt exist"
mkdir /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/iaas-swarm/sqldata
