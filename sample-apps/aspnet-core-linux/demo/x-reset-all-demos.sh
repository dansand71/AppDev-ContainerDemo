#!/bin/bash
echo "This Script resets all demo's to the defaul state."
#az account set --subscription "Microsoft Azure Internal Consumption"
echo "Cleanup ACS"
./acs-demo/x-reset-demo.sh
echo "-----------------------------"
echo "Cleanup IaaS"
./iaas-demo/x-reset-demo.sh
echo "-----------------------------"
echo "Cleanup PaaS"
./paas-demo/x-reset-demo.sh
echo "-----------------------------"
echo "done with cleanup."

