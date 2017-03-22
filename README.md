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
4. run the 1-CreateSettingsFile.sh environment template file creation script
5. after editing the template file with your values run the 2-SetupDemo.sh script

## SCRIPT to Install
```
sudo mkdir /source
sudo git clone https://github.com/dansand71/AppDev-ContainerDemo
sudo chmod +x /source/AppDev-ContainerDemo/1-CreateSettingsFile.sh
sudo chmod +x /source/AppDev-ContainerDemo/2-SetupDemo.sh
sudo chmod +x /source/AppDev-ContainerDemo/RefreshDemo.sh
/source/AppDev-ContainerDemo/1-CreateSettingsFile.sh
```

The script installs / updates:
- Azure CLI v2 on the Jumpbox server

Configures Azure:
- Creates ossdemo-appdev-acs resource group, opens port 22
- Creates ossdemo-appdev-iaas resource group, opens port 22, 80
- Creates ossdemo-appdev-paas resource group, opens port 80

Creates:
- 2 docker CENTOS servers in ossdemo-appdev-iaas RG
- 1 kubernetes cluster with 1 master and 3 agents



