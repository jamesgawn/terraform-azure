terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.76.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "gawnbackend"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }

}

resource "azurerm_resource_group" "k8s-cluster" {
  name     = "k8s-cluster"
  location = "UK South"
}

resource "azurerm_kubernetes_cluster" "k8s-cluster" {
  name                = "k8s-cluster-gawn"
  location            = azurerm_resource_group.k8s-cluster.location
  resource_group_name = azurerm_resource_group.k8s-cluster.name
  dns_prefix          = "k8s-cluster-gawn"
  
  automatic_channel_upgrade = "stable"

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "Basic"
  }

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    enable_auto_scaling = true
    min_count = 1
    max_count = 3
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      default_node_pool[0].node_count,
    ]
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s-cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s-cluster.kube_config_raw

  sensitive = true
}