#Set Scripts as executable
echo ".setting scripts as executables"
find .  -type f -name "*.sh" -exec sudo chmod +x {} \;