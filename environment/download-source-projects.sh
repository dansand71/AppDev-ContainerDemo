#!/bin/bash
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"

echo "Download source for the samples."
sourcedir="/source/AppDev-ContainerDemo/sample-apps"
sampleList=(
    "${sourcedir}/aspnet-core-linux"
    "${sourcedir}/drupal"
    "${sourcedir}/eShopOnContainers"
    "${sourcedir}/nodejs-todo"
)
for sample in "${sampleList[@]}"
do
    echo -e "${BOLD}Working on $sample ${RESET}"
    pushd $sample
    ./download-source.sh
    popd
done