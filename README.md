# AppDev-ContainerDemo
OSS on Azure Demos framework - AppDev with simple containers

This project builds from the https://github.com/dansand71/OSSonAzure environment setup.  This demo shows:
- Linux Containers on Azure with Docker, K8S and Azure Linux PaaS and .NET Core
- Azure Management integration with Application Insights and OMS for containers and Linux infrastructure
- Image creation and migration to Azure for RHEL, Centos and Ubuntu VM's
- and many more to come....


To get started with these demo's:
1. ensure you have a running jumpbox as outlined in the OSSonAzure repository
2. clone this project from git
3. mark the scripts as executable
4. run the 1-create-settings-file.sh environment template file creation script
5. after editing the template file with your values run the 2-setup-demo.sh script

## SCRIPT to Install
```
sudo mkdir /source
sudo git clone https://github.com/dansand71/AppDev-ContainerDemo
sudo chmod +x /source/AppDev-ContainerDemo/1-create-settings-file.sh
sudo chmod +x /source/AppDev-ContainerDemo/2-setup-demo.sh
sudo chmod +x /source/AppDev-ContainerDemo/RefreshDemo.sh
/source/AppDev-ContainerDemo/1-create-settings-file.sh
```

The script installs / updates:
- Azure CLI v2 on the Jumpbox server
- Docker CE 17
- Docker compose

Configures Azure:
- Creates ossdemo-appdev-acs resource group, opens port 22
- Creates ossdemo-appdev-iaas resource group, opens port 22, 80
- Creates ossdemo-appdev-paas resource group, opens port 80

Creates:
- 2 docker CENTOS servers in ossdemo-appdev-iaas RG
- 1 kubernetes cluster with 1 master and 3 agents

DEMO's Available:
- template aspnetcore on linux mvc app.  Demonstrate IaaS deployment with Ansible, Private Registry, ACS with Kubernetes, Azure App Service with PaaS
- eShopOnContainer demo - multi-tier application showing microservices and SQL On Linux


## SCRIPT to Configure Demo 1.  Sample ASP.net core app in containers.
```
/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/1-setup-demo.sh
/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/2-docker-setup.sh
/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/3-deploy-OMS-agent.sh
/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/4-build-deploy-containers.sh
```

## SCRIPT to Configure Demo 2.  Sample ASP.net core app on ACS with Kubernetes.
```
/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/acs-demo/1-setup-demo.sh
/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/2-deploy-OMS-daemonset.sh
/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/3-deploy-expose-service.sh
/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/iaas-demo/4-browse-k8s-cluster.sh
```

## SCRIPT to Configure Demo 3.  Sample ASP.net core app on App Service with Linux PaaS.
```
/source/AppDev-ContainerDemo/sample-apps/aspnet-core-linux/setupdemo/paas-demo/1-setup-demo.sh
```


