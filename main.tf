resource "azurerm_resource_group" "main" {
  name     = "vnet2vnet-rg"
  location = "East US2"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "devnet1"
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.5.0.0/16"]
  location            = azurerm_resource_group.main.location
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "devnet2"
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.7.0.0/16"]
  location            = azurerm_resource_group.main.location
}

# Create Subnets
resource "azurerm_subnet" "sub1" {
  name                 = "devsubpub"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.5.1.0/24"]
}

resource "azurerm_subnet" "sub2" {
  name                 = "devsubpri"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.7.1.0/24"]
}

resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}
