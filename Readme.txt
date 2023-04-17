Project Overview:

Our project will create a virtual network and a virtual machine in Azure. The virtual machine will be running Ubuntu Linux and will have a public IP address, allowing us to connect to it remotely.

Prerequisites:

Before we begin, make sure you have the following:

An Azure account and subscription ID
Terraform installed on your local machine
Step 1: Set up the Terraform environment

First, create a new directory for our project and initialize a new Terraform project.

shell
Copy code
$ mkdir terraform-azure-project
$ cd terraform-azure-project
$ terraform init
Step 2: Define the Azure provider and authentication details

Next, we need to define the Azure provider and authentication details. Create a new file called provider.tf and add the following code:

arduino
Copy code
provider "azurerm" {
  subscription_id = "<your-subscription-id>"
  features {}
}
Make sure to replace <your-subscription-id> with your actual Azure subscription ID.

Step 3: Define the virtual network resource

Now, let's define the virtual network resource. Create a new file called network.tf and add the following code:

arduino
Copy code
resource "azurerm_virtual_network" "my_vnet" {
  name                = "my-terraform-network"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = "my-terraform-group"
}
This code will create a new virtual network named "my-terraform-network" with an address space of 10.0.0.0/16 in the East US region. We've also specified the name of the resource group as "my-terraform-group".

Step 4: Define the virtual machine resource

Now, let's define the virtual machine resource. Create a new file called vm.tf and add the following code:

java
Copy code
resource "azurerm_network_interface" "my_nic" {
  name                = "my-terraform-nic"
  location            = "eastus"
  resource_group_name = "my-terraform-group"

  ip_configuration {
    name                          = "my-terraform-ipconfig"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "my-terraform-subnet"
  resource_group_name  = "my-terraform-group"
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "my_public_ip" {
  name                = "my-terraform-public-ip"
  location            = "eastus"
  resource_group_name = "my-terraform-group"
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "my_nsg" {
  name                = "my-terraform-nsg"
  location            = "eastus"
  resource_group_name = "my-terraform-group"
}

resource "azurerm_network_interface_security_group_association" "my_nsg_association" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = "my-terraform-vm"
  location           