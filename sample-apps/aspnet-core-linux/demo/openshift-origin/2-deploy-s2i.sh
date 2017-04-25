#SSH to master
ssh VALUEOF-DEMO-ADMIN-USER-NAME@VALUEOF-UNIQUE-SERVER-PREFIX-ossdemo-oshift-master.eastus.cloudapp.azure.com "
echo 'Logging into Openshift'
echo 'ssh VALUEOF-DEMO-ADMIN-USER-NAME@VALUEOF-UNIQUE-SERVER-PREFIX-ossdemo-oshift-master.eastus.cloudapp.azure.com'
oc login
oc create -n openshift -f https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/templates/dotnet-example.json
echo 'Creating new project'
#Create new project
oc new-project aspnet-core-linux-s2i
oc project aspnet-core-linux-s2i
oc status


#S2I app example
#https://github.com/openshift-s2i/s2i-aspnet    
oc new-build https://github.com/openshift-s2i/s2i-aspnet
oc new-app registry.access.redhat.com/dotnet/dotnetcore-11-rhel7~https://github.com/dansand71/sampleApp-s2i-aspnetcore:dotnetcore-1.1 --name=aspnet-s2i-app --context-dir=app
oc expose service aspnet-s2i-app

"
echo "Please login to the Openshift origin cluster: https://VALUEOF-UNIQUE-SERVER-PREFIX-ossdemo-oshift-master.eastus.cloudapp.azure.com:8443 "
