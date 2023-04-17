# Create a new resource group
resource "azurerm_resource_group" "terraform" {
  name     = "my-terraform-group"
  location = "eastus"
}

# Create a virtual network
resource "azurerm_virtual_network" "my_vnet" {
  name                = "my-terraform-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
}

# Create a public IP address
resource "azurerm_public_ip" "my_public_ip" {
  name                = "my-terraform-public-ip"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
  allocation_method   = "Static"
}

# Create a network security group
resource "azurerm_network_security_group" "my_nsg" {
  name                = "my-terraform-nsg"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
}

# Create a network interface
resource "azurerm_network_interface" "my_nic" {
  name                = "my-terraform-nic"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name

  ip_configuration {
    name                          = "my-terraform-ipconfig"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip.id
  }
}
resource "azurerm_network_interface_security_group_association" "my_nsg_association" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

# Create a subnet
resource "azurerm_subnet" "my_subnet" {
  name                 = "my-terraform-subnet"
  resource_group_name  = azurerm_resource_group.terraform.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "example" {
  name                = "my-terraform-vm"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
  size                = "Standard_B1s"
  disable_password_authentication = false
  admin_username      = ""
  admin_password      = ""
  network_interface_ids = [
    azurerm_network_interface.my_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name = "myvm"
}
