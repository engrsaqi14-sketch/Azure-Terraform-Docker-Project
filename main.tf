resource "azurerm_public_ip" "public_ip" {
  count               = var.vm_count
  name                = "${var.env}-public-ip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.env}-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "firstvm_nsg" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = var.nsg_id
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "vm_blob_access" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_virtual_machine.firstvm[0].identity[0].principal_id
}

resource "azurerm_linux_virtual_machine" "firstvm" {
  count               = var.vm_count
  name                = "${var.env}-webserver-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size

  identity {
    type = "SystemAssigned"
  }

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Name = "${var.env}-webserver-${count.index + 1}"
  }

custom_data = base64encode(<<-EOF
  #!/bin/bash

  apt-get update -y

  apt-get install -y docker.io

  systemctl enable docker
  systemctl start docker

  docker pull ${var.docker_image}

  docker run -d \
    --name cloud-devops-website \
    --restart unless-stopped \
    -p 80:80 \
    ${var.docker_image}
EOF
)

}


