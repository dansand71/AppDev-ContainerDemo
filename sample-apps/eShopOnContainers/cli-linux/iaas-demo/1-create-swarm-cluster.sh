/source/AppDev-ContainerDemo/environment/iaas/create-swarm-cluster.sh

sudo docker stack deploy --compose-file visualizer.yml monitoring

#this is to show a temporary scenario that we store data from the linux container into a local directory on the jumpbox server
mkdir /source/AppDev-ContainerDemo/sample-apps/eShopOnContainers/cli-linux/iaas-demo/sqldata
