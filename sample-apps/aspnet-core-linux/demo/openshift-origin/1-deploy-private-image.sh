#SSH to master
ssh VALUEOF-DEMO-ADMIN-USER-NAME@VALUEOF-UNIQUE-SERVER-PREFIX-ossdemo-oshift-master.eastus.cloudapp.azure.com "
echo 'Logging into Openshift'
oc login -u system:login
#oc create -n openshift -f https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/templates/dotnet-example.json
echo 'Creating new project'
#Create new project
oc new-project aspnet-core-linux
oc project aspnet-core-linux
oc status
echo 'Creating secret if it doesnt already exist'
#Create Secret for logging into the Azure Registry - for use if you want to show the image pull vs S2I demos
oc secrets new-dockercfg ossdemoregistrykey \
        --docker-server=VALUEOF-REGISTRY-SERVER-NAME \
        --docker-username=VALUEOF-REGISTRY-USER-NAME \
        --docker-password=VALUEOF-REGISTRY-PASSWORD \
        --docker-email=GBBOSS@microsoft.com

oc secrets link default ossdemoregistrykey --for=pull
echo 'Updating security policy'
#https://docs.openshift.org/latest/admin_guide/manage_scc.html#enable-images-to-run-with-user-in-the-dockerfile
oadm policy add-scc-to-group anyuid system:authenticated

echo 'Creating new app with image as the base'
#Image app example
oc new-app --docker-image=VALUEOF-REGISTRY-SERVER-NAME/ossdemo/aspnet-core-linux:latest --insecure-registry=true --name=aspnet-image

#expose app
echo 'Exposing a default route to the application'
oc expose service aspnet-image

"
echo "Please login to the Openshift origin cluster: https://VALUEOF-UNIQUE-SERVER-PREFIX-ossdemo-oshift-master.eastus.cloudapp.azure.com:8443 "
