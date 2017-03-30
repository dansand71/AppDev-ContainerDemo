#!/bin/bash
echo "Delete the app service and plans"
#az account set --subscription "Microsoft Azure Internal Consumption"

## Delete the appservice
az appservice web delete -g ossdemo-appdev-paas -n aspnet-core-linux-paas

## Delete the plan
az appservice plan delete -g ossdemo-appdev-paas -n webtier-plan 