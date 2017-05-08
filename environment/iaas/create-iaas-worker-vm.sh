echo "Creating Docker Runtime hosts for Demo #1 in ossdemo-iaas resource group."
echo ""
echo "----------------------------------"
#remove this server in case we have seen it before on the jumpbox
ssh-keygen -R "svr1-VALUEOF-UNIQUE-SERVER-PREFIX"
echo "Create VM #1 & add it to the availability set and vnet"
~/bin/az vm create -g 'ossdemo-appdev-iaas' -n svr1-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'svr1-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr1-disk' --image "OpenLogic:CentOS:7.2:latest" --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2  --admin-username VALUEOF-DEMO-ADMIN-USER-NAME \
        --availability-set 'ossdemo-appdev-iaas-availabilityset' \
        --nics svr1-nic \
        --ssh-key-value 'REPLACE-SSH-KEY' 
        #--no-wait \
echo ""
echo "----------------------------------"
ssh-keygen -R "svr2-VALUEOF-UNIQUE-SERVER-PREFIX"
echo "Create VM #2 & add it to the availability set and vnet"
~/bin/az vm create -g 'ossdemo-appdev-iaas' -n svr2-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'svr2-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr2-disk' --image "OpenLogic:CentOS:7.2:latest" --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2 --admin-username VALUEOF-DEMO-ADMIN-USER-NAME  \
        --availability-set 'ossdemo-appdev-iaas-availabilityset' \
        --nics svr2-nic \
        --ssh-key-value 'REPLACE-SSH-KEY'
        #--no-wait \


#echo "Create VM #RHEL"
#az vm create -g 'ossdemo-appdev-iaas' -n svr3-VALUEOF-UNIQUE-SERVER-PREFIX \
#        --public-ip-address-dns-name 'svr3-VALUEOF-UNIQUE-SERVER-PREFIX' \
#        --os-disk-name 'svr3-disk' --image "RedHat:RHEL:7.2:latest" --os-type linux --storage-sku 'Premium_LRS' \
#        --size Standard_DS1_v2 --admin-username gbbossdemo  \
#        --nsg 'NSG-ossdemo-appdev-iaas' --availability-set 'ossdemo-appdev-iaas-availabilityset' \
#        --no-wait \
#        --ssh-key-value 'REPLACE-SSH-KEY'

#To Resize disks later - https://blogs.msdn.microsoft.com/cloud_solution_architect/2016/05/24/step-by-step-how-to-resize-a-linux-vm-os-disk-in-azure-arm/