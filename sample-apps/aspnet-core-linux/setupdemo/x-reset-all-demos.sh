#!/bin/bash
echo "This Script resets all demo's to the defaul state."
#az account set --subscription "Microsoft Azure Internal Consumption"
./acs-demo/x-reset-demo.sh
./iaas-demo/x-reset-demo.sh
./paas-demo/xreset-demo.sh

