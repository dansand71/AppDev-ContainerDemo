#Set Scripts as executable
echo ".setting scripts as executables"
find .  -type f -name "*.sh" -exec sudo chmod +x {} \;

find .  -type f -name "*.sh" -exec sudo dos2unix {} \;
find .  -type f -name "*.json" -exec sudo dos2unix {} \;