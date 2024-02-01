########################
## KUBERNETES CLUSTER ##
########################

resource "azurerm_kubernetes_cluster" "main" {
  location                          = local.location
  name                              = "${local.resource_prefix}-aks-main"
  resource_group_name               = data.azurerm_resource_group.main.name
  node_resource_group               = "${local.resource_prefix}-rg-aks-nodes"
  dns_prefix                        = "kubernetes"
  tags                              = local.tags
  kubernetes_version                = var.aks.version.control_plane
  role_based_access_control_enabled = true
  local_account_disabled            = false

  # default node pool is always of Mode "System"
  default_node_pool {
    name                = "system"
    vm_size             = var.aks.default_node_pool.vm_size
    os_disk_type        = "Managed"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = var.aks.default_node_pool.min_count
    max_count           = var.aks.default_node_pool.max_count
    # vnet_subnet_id       = azurerm_subnet.k8s.id
    orchestrator_version = var.aks.version.node_pool
    upgrade_settings {
      max_surge = "10%"
    }
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
    dns_service_ip = "172.18.0.10"
    pod_cidr       = "172.17.0.0/16"
    service_cidr   = "172.18.0.0/16"

#    load_balancer_profile {
#      outbound_ip_address_ids = [
#        azurerm_public_ip.ingress.id
#      ]
#    }
  }

  # Azure AD authentication with Azure RBAC
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    managed            = true
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.monitoring.id
    msi_auth_for_monitoring_enabled = true
  }

  # key_vault_secrets_provider {
  #   secret_rotation_enabled  = true
  #   secret_rotation_interval = "30m"
  # }
}

######################
## ROLE ASSIGNMENTS ##
######################

# for nginx to be able to get the ip
#resource "azurerm_role_assignment" "aks_rg_nw_contr" {
#  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
#  scope                = data.azurerm_resource_group.main.id
#  role_definition_name = "Network Contributor"
#}

# assign cluster admin role to me
resource "azurerm_role_assignment" "aks_cluster_admin_to_sp" {
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
}

# allow cluster to pull images from acr
#resource "azurerm_role_assignment" "aks_acr_pull" {
#  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
#  scope                = azurerm_container_registry.main.id
#  role_definition_name = "AcrPull"
#}

// wait two minutes
resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
  depends_on = [
    azurerm_role_assignment.aks_cluster_admin_to_sp,
    // azurerm_role_assignment.aks_acr_pull,
    // azurerm_role_assignment.aks_rg_nw_contr
  ]
}

resource "null_resource" "get-credentials" {
  provisioner "local-exec" {
    command="az aks get-credentials -g ${data.azurerm_resource_group.main.name} -n ${azurerm_kubernetes_cluster.main.name} --overwrite-existing"
  }
  depends_on = [
    null_resource.wait
  ]
}
