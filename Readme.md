Project Overview:

Our project will create a virtual network and a virtual machine in Azure. The virtual machine will be running Ubuntu Linux and will have a public IP address, allowing us to connect to it remotely.

Prerequisites:

Before we begin, make sure you have the following:

An Azure account and subscription ID
Terraform installed on your local machine

Step 1: Set up the Terraform environment

First, create a new directory for our project and initialize a new Terraform project.


$ mkdir terraform-azure-project
$ cd terraform-azure-project
$ terraform init

Step 2: Define the Azure provider and authentication details

provider "azurerm" {
  subscription_id = "<your-subscription-id>"
  features {}
}

Step 3: Define the virtual network resource

Step 4: Define the virtual machine resource

