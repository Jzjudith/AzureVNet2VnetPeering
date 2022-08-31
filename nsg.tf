#create network security groups
resource "azurerm_network_security_group" "nsg1" {
  name                = "vnetpublic-nsg"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  security_rule {
    name                       = "Allow-SSH-Access"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "10.5.0.0/16" # "VirtualNetwork"
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow-In-Internet"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_address_prefix = "10.5.0.0/16" # "VirtualNetwork"
    destination_port_range     = "80"
  }
  security_rule {
    name                       = "Allow-Out-Internet"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.5.0.0/16"
    source_port_range          = "*"
    destination_address_prefix = "Internet" # 
    destination_port_range     = "80"
  }

  security_rule {
    name                       = "Allow-HttpsIn-Internet"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_address_prefix = "10.5.0.0/16" # "VirtualNetwork"
    destination_port_range     = "443"
  }
  security_rule {
    name                       = "Allow-HttpsOut-Internet"
    priority                   = 105
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.5.0.0/16"
    source_port_range          = "*"
    destination_address_prefix = "Internet" # 
    destination_port_range     = "443"
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.sub1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_network_security_group" "nsg2" {
  name                = "uksouthvnetprivate-nsg"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location


  security_rule {
    name                       = "Allow-HttpsIn"
    priority                   = 204
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.5.0.0/24"
    source_port_range          = "*"
    destination_address_prefix = "10.7.0.0/24" # "VirtualNetwork"
    destination_port_range     = "443"
  }
  security_rule {
    name                       = "Allow-HttpsOut-Internet"
    priority                   = 205
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.7.0.0/16"
    source_port_range          = "*"
    destination_address_prefix = "10.5.0.0/24" #'VirtualNetwork'
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "Allow-ICMP-In"
    priority                   = 206
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.5.0.0/24"
    source_port_range          = "*"
    destination_address_prefix = "10.7.0.0/16" #Virtual network
    destination_port_range     = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "main2" {
  subnet_id                 = azurerm_subnet.sub2.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}