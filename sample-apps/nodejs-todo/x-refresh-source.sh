#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"
projectdir="/source/AppDev-ContainerDemo/sample-apps/nodejs-todo"

echo -e "${BOLD}Deleting the source and re-cloning from master...${RESET}"
rm -rf ${projectdir}/src
mkdir -p ${projectdir}/src
cd ${projectdir}/src
git clone https://github.com/dansand71/sampleApp-eShopOnContainers .
echo -e ".clone from master complete."

