#SSH to master
ssh VALUEOF-DEMO-ADMIN-USER-NAME@VALUEOF-UNIQUE-SERVER-PREFIX-ossdemo-oshift-master.eastus.cloudapp.azure.com

oc login
#oc create -n openshift -f https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/templates/dotnet-example.json

#Create new project
oc new-project aspnet-core-linux
oc project aspnet-core-linux
oc status

#Create Secret for logging into the Azure Registry - for use if you want to show the image pull vs S2I demos
oc secrets new-dockercfg ossdemoregistrykey \
        --docker-server=VALUEOF-REGISTRY-SERVER-NAME \
        --docker-username=VALUEOF-REGISTRY-USER-NAME \
        --docker-password=VALUEOF-REGISTRY-PASSWORD \
        --docker-email=GBBOSS@microsoft.com

oc secrets link default ossdemoregistrykey --for=pull

#Image app example
#oc new-app --docker-image=VALUEOF-REGISTRY-SERVER-NAME/ossdemo/aspnet-core-linux:latest --insecure-registry=true


#S2I app example
#https://github.com/openshift-s2i/s2i-aspnet    
#oc new-build https://github.com/openshift-s2i/s2i-aspnet
oc new-app registry.access.redhat.com/dotnet/dotnetcore-11-rhel7~https://github.com/dansand71/sampleApp-s2i-aspnetcore:dotnetcore-1.1 --name=aspnet-app --context-dir=app
oc service expose aspnet-app

echo "Please login to the Openshift origin cluster: https://VALUEOF-UNIQUE-SERVER-PREFIX-ossdemo-oshift-master.eastus.cloudapp.azure.com:8443 "
