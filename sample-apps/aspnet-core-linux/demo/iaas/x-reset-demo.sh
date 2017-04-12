#!/bin/bash
echo "Delete the image on SVR 1 and Svr 2"
#az account set --subscription "Microsoft Azure Internal Consumption"
echo ".running: ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX sudo docker rm aspnet-core-linux -f"
ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr1-VALUEOF-UNIQUE-SERVER-PREFIX sudo docker rm aspnet-core-linux -f
echo ".running: ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr2-VALUEOF-UNIQUE-SERVER-PREFIX sudo docker rm aspnet-core-linux -f"
ssh VALUEOF-DEMO-ADMIN-USER-NAME@svr2-VALUEOF-UNIQUE-SERVER-PREFIX sudo docker rm aspnet-core-linux -f