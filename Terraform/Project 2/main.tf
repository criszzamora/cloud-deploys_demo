# Specify the provider
provider "azurerm" {
  features {}
}

# Define the resource group
resource "azurerm_resource_group" "cris_rg" {
  name     = "cris-resource-group"
  location = "East US"
}

# Create a virtual network
resource "azurerm_virtual_network" "cris_vnet" {
  name                = "cris-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.cris_rg.location
  resource_group_name = azurerm_resource_group.cris_rg.name
}

# Create a subnet for the AKS cluster
resource "azurerm_subnet" "cris_subnet" {
  name                 = "cris-subnet"
  resource_group_name  = azurerm_resource_group.cris_rg.name
  virtual_network_name = azurerm_virtual_network.cris_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create the AKS cluster
resource "azurerm_kubernetes_cluster" "cris_cluster" {
  name                = "cris-cluster"
  location            = azurerm_resource_group.cris_rg.location
  resource_group_name = azurerm_resource_group.cris_rg.name
  dns_prefix          = "cris-cluster-dns"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.cris_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    dns_service_ip    = "10.0.2.10"
    service_cidr      = "10.0.2.0/24"
    docker_bridge_cidr = "172.17.0.1/16"
  }
}

# Output the AKS cluster information
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.cris_cluster.name
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cris_cluster.kube_config_raw
  sensitive = true
}
