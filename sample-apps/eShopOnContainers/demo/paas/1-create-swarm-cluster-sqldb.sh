read -p "Create SWARM Cluster? [Y/n]:"  continuescript
if [[ ${continuescript,,} != "n" ]];then
  echo "Creating SWARM Cluster."
  /source/AppDev-ContainerDemo/environment/iaas/create-swarm-cluster.sh
fi

read -p "Create SQL PAAS Server? [Y/n]:"  continuescript
if [[ ${continuescript,,} != "n" ]];then
echo "Creating SQL Server in ossdemo-utility resource group."
### SQL SERVER PASSWORD
while true
do
  read -s -p "$(echo -e -n "${INPUT}Please enter new admin password for SQL:${RESET}")" NEWPassword
  echo ""
  read -s -p "$(echo -e -n "${INPUT}Re-enter to verify:${RESET}")" NEWPassword2
  
  if [ $NEWPassword = $NEWPassword2 ]
  then
     break 2
  else
     echo -e ".${RED}Passwords do not match.  Please retry. ${RESET}"
  fi
done
echo ".verified password.  Running command to create SQL Server."
~/bin/az sql server create --name ossdemo-sql-VALUEOF-UNIQUE-SERVER-PREFIX --resource-group ossdemo-utility --location eastus \
    --admin-user VALUEOF-DEMO-ADMIN-USER-NAME --admin-password $NEWPassword

echo ".allowing Azure traffic to the new SQL Server"
~/bin/az sql server firewall-rule create -g ossdemo-utility -s ossdemo-sql-VALUEOF-UNIQUE-SERVER-PREFIX --end-ip-address "0.0.0.0" --name AllowAllWindowsAzureIps --start-ip-address "0.0.0.0"


echo "Replacing values in the STACK deployment file."
sed -i -e "s@REPLACESQLADMIN@VALUEOF-DEMO-ADMIN-USER-NAME@g" docker-stack.yml
sed -i -e "s@REPLACESQLPASSWORD@$NEWPassword@g" docker-stack.yml
sed -i -e "s@REPLACESQLSERVER@ossdemo-sql-VALUEOF-UNIQUE-SERVER-PREFIX.database.windows.net@g" docker-stack.yml

fi