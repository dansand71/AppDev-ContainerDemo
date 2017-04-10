#Set Scripts as executable
echo ".setting scripts as executables"
find .  -type f -name "*.sh" -exec sudo chmod +x {} \;
echo ".running dos2unix on .sh files"
find .  -type f -name "*.sh" -exec sudo dos2unix {} -q \; &> /dev/null
echo ".running dos2unix on .json files"
find .  -type f -name "*.json" -exec sudo dos2unix {} \; &> /dev/null
echo ".running dos2unix on .yml files"
find .  -type f -name "*.yml" -exec sudo dos2unix {} \; &> /dev/null