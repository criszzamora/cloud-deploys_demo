# Resource group
resource "azurerm_resource_group" "cris_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Virtual network
resource "azurerm_virtual_network" "cris_vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address]
  location            = azurerm_resource_group.cris_rg.location
  resource_group_name = azurerm_resource_group.cris_rg.name
}

# AKS cluster subnet
resource "azurerm_subnet" "cris_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.cris_rg.name
  virtual_network_name = azurerm_virtual_network.cris_vnet.name
  address_prefixes     = [var.subnet_address]
}

# AKS cluster
resource "azurerm_kubernetes_cluster" "cris_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.cris_rg.location
  resource_group_name = azurerm_resource_group.cris_rg.name
  dns_prefix          = var.cluster_dns-prefix

  default_node_pool {
    name            = var.default-node-pool_name
    node_count      = var.default-node-pool_count
    vm_size         = var.default-node-pool_vmsize
    vnet_subnet_id  = azurerm_subnet.cris_subnet.id
  }

  identity {
    type = var.identity-type
  }

  role_based_access_control {
    enabled = var.rbac_status
  }

  network_profile {
    network_plugin      = var.network-plugin
    network_policy      = var.network-policy
    dns_service_ip      = var.network-dns
    service_cidr        = var.network-cidr
    docker_bridge_cidr  = var.network-bridge
  }
}