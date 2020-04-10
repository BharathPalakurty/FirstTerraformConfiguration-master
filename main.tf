provider "azurerm" {
  version = "=2.0.0"
  features { }  
}
resource "azurerm_resource_group" "rg"{
  name     = var.resourceGroupName
  location = var.location
}
resource "azurerm_virtual_network" "vnet1" {

  name = var.vnet-kube
  resource_group_name = var.resourceGroupName
  location = var.location
  address_space = [
    "10.240.0.0/16"]
  subnet {
    address_prefix = "10.240.0.0/24"
    name = "kubernetes-subnet"
  }
}

  resource "azurerm_network_security_group" "nsg" {
    name                = "kubernetes-nsg"
    location            = var.location
    resource_group_name = var.resourceGroupName

    security_rule {
      name                       = "kubernetes_allow_ssh"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 22
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    security_rule {
      name                       = "kubernetes_allow_api_server"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 6443
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }


resource "azurerm_lb" "kb-lb" {
  name = "kubernetes-lb"
  location = var.location
  resource_group_name = var.resourceGroupName

  frontend_ip_configuration {
    name                 = "kube-fromt-end-ip"
    public_ip_address_id = azurerm_public_ip.kb_lb_pip.id
  }

}
  resource "azurerm_lb_backend_address_pool" "kb_lb_pool" {
    loadbalancer_id     = azurerm_lb.kb-lb.id
    name                = "kubernetes-lb-pool"
    resource_group_name = var.resourceGroupName
  }

resource "azurerm_public_ip" "kb_lb_pip" {
  name                = "kubernetes-pip"
  location            = var.location
   resource_group_name = var.resourceGroupName
  allocation_method   = "Static"
}


resource "azurerm_availability_set" "controller-avilaibility_set" {
  name                = "controller-as"
  location            = var.location
  resource_group_name = var.resourceGroupName

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "controller-pips" {
  count = 2
  name                = "controller-${count.index}-pip"
  location            = var.location
  resource_group_name = var.resourceGroupName
  allocation_method   = "Static"
}
/*
resource "azurerm_network_interface" "controller-nics" {
 count = 2
  name                = "controller${count.index}-nic"
  private_ip_address= "10.240.0.1${count.index}"
  public_ip_address = "controller-${count.index}-pip"
  //vnet=var.vnet-kube
  //subnet="kubernetes-subnet"
  enable_ip_forwarding = true
 // lb-name="kubernetes-lb"
  //lb-address-pool=azurerm_lb_backend_address_pool.kb_lb_pool
  location            = var.location
  resource_group_name = var.resourceGroupName
  ip_configuration {
    name                          = "internal"
    //subnet_name                     = azurerm_virtual_network.vnet1.subnet.name
    private_ip_address_allocation = "Dynamic"
  }
}
*/
