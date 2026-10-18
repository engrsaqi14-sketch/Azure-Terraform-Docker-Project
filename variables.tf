
variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "austriaeast"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "subnet_id" {
  type = string
}

variable "nsg_id" {
  type = string
}

variable "vm_count" {
  type    = number
  default = 1
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "public_key_path" {
  type = string
}

variable "env" {
  type    = string
  default = "dev"
}
variable "storage_account_name" {
  type = string
}

variable "container_name" {
  type    = string
  default = "app-data"
}
variable "docker_image" {
  description = "Public Docker Hub image for the company website"
  type        = string
}