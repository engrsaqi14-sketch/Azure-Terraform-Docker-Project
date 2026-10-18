
subscription_id     = "e886631d-7b43-466c-930e-ddc7099ceb5a"
resource_group_name = "dev-Vm_group"
location            = "austriaeast"

subnet_id = "/subscriptions/e886631d-7b43-466c-930e-ddc7099ceb5a/resourceGroups/dev-Vm_group/providers/Microsoft.Network/virtualNetworks/dev-Vm-vnet/subnets/default"

nsg_id = "/subscriptions/e886631d-7b43-466c-930e-ddc7099ceb5a/resourceGroups/dev-Vm_group/providers/Microsoft.Network/networkSecurityGroups/dev-Vm-nsg"

vm_size         = "Standard_B2ats_v2"
vm_count        = 1
admin_username  = "Devops-saqib"
public_key_path = "C:/Users/DELL/projects/azure-project/azure_key.pub"
env             = "dev"

storage_account_name = "devwebstorage12345"
container_name       = "app-data"

docker_image = "saqib1devops/cloud-devops-website:1.0"