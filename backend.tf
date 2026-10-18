
terraform {
  backend "azurerm" {
    resource_group_name  = "dev-Vm_group"
    storage_account_name = "devsaqibtfstate2026"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
