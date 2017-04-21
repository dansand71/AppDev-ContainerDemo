#!/bin/bash
echo "Delete the service and deployment which will cleanup the pods and external IP's'"
#az account set --subscription "Microsoft Azure Internal Consumption"
kubectl delete service nodejs-todo
kubectl delete service nosqlsvc
kubectl delete deployment nodejs-todo-deployment
kubectl delete deployment nosqlsvc-deployment

#reset the database connection string in case it has changed
echo "module.exports = {
    remoteUrl : 'mongodb://nosqlsvc:27017/todo',
    localUrl: 'mongodb://nosqlsvc:27017/todo'
};" > /source/AppDev-ContainerDemo/sample-apps/nodejs-todo/src/config/database.js
