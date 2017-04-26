echo "Download source for the samples."
sourcedir="/source/AppDev-ContainerDemo/sample-apps/"
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