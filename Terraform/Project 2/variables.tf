##########################
#Auth credentials
variable "subscription_id" {
    description = "Subscription ID"
    type = string
    default = ""
}
variable "client_id" {
    description = "Client ID"
    type = string
    default = ""
}
variable "client_secret" {
    description = "Client Secret"
    type = string
    default = ""
}
variable "tenant_id" {
    description = "Tenant ID"
    type = string
    default = ""
}



##########################
#Resource group
variable "resource_group_name" {
    description = "Reasource group name"
    type = string
    default = "cris-rg"
  
}
variable "resource_group_location" {
    description = "Rsource group location"
    type = string
    default = "eastus2"
  
}



##########################
#Virtual Network
variable "vnet_name" {
    description = "Virtual network name"
    type = string
    default = "cris-vnet"
  
}
variable "vnet_address" {
    description = "IP address for vm vnet"
    type = string
    default = "10.0.0.0/16"
}



##########################
#Subnet
variable "subnet_name" {
    description = "Subnet name"
    type = string
    default = "cris-subnet"
  
}
variable "subnet_address" {
    description = "IP address for subnet"
    type = string
    default = "10.0.1.0/24"
}



##########################
#Cluster
variable "cluster_name" {
    description = "AKS Cluster name"
    type = string
    default = "cris-cluster"
}
variable "cluster_dns-prefix" {
    description = "AKS Cluster dns prefix"
    type = string
    default = "default"
}
variable "default-node-pool_name" {
    description = "Default node pool name"
    type = string
    default = "default"
}
variable "default-node-pool_count" {
    description = "Default node pool node count"
    type = string
    default = "2"
}
variable "default-node-pool_vmsize" {
    description = "Default node pool vm size"
    type = string
    default = "Standard_DS2_v2"
}
variable "identity-type" {
    description = "Identity type"
    type = string
    default = "SystemAssigned"
}
variable "rbac_status" {
    description = "RBAC status"
    type = string
    default = "true"
}
#Network profile
variable "network-plugin" {
    description = "Network plugin"
    type = string
    default = "azure"
}
variable "network-policy" {
    description = "Network policy"
    type = string
    default = "calico"
}
variable "network-dns" {
    description = "Network dns service ip"
    type = string
    default = "10.0.2.10"
}
variable "network-cidr" {
    description = "Network service cidr"
    type = string
    default = "10.0.2.0/24"
}
variable "network-bridge" {
    description = "Network docker bridge cidr"
    type = string
    default = "172.17.0.1/16"
}
