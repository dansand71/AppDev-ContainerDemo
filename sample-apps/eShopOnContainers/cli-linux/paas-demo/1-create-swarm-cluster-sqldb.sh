echo "Creating SWARM Cluster."
/source/AppDev-ContainerDemo/environment/iaas/create-swarm-cluster.sh

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

~/bin/az sql server create --name ossdemo-sql-VALUEOF-UNIQUE-SERVER-PREFIX --resource-group ossdemo-utility --location eastus \
    --admin-user VALUEOF-DEMO-ADMIN-USER-NAME --admin-password $NEWPASSWORD

echo "Replacing values in the STACK deployment file."
sed -i -e "s@REPLACESQLADMIN@VALUEOF-DEMO-ADMIN-USER-NAME@g" docker-stack.yml
sed -i -e "s@REPLACESQLPASSWORD@$NEWPASSWORD@g" docker-stack.yml
sed -i -e "s@REPLACESQLSERVER@ossdemo-sql-VALUEOF-UNIQUE-SERVER-PREFIX.database.windows.net@g" docker-stack.yml