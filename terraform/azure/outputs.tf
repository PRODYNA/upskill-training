output "resource_group" {
  value = azurerm_resource_group.main
}

output "kubernetes_cluster" {
  value     = azurerm_kubernetes_cluster.main
  sensitive = true
}

output "log_analytics_workspace" {
  value     = azurerm_log_analytics_workspace.monitoring
  sensitive = true
}

output "application_insights" {
  value     = azurerm_application_insights.monitoring
  sensitive = true
}

output "container_registry" {
  value     = azurerm_container_registry.main
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.ingress
}

output "ingress_ip" {
  value = azurerm_public_ip.ingress.ip_address
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "ingress_ip_name" {
  value = azurerm_public_ip.ingress.name
}

output "fq_image_name" {
  value = "${azurerm_container_registry.main.login_server}/${local.image.repository}"
}

output "image_tag" {
  value = local.image.tag
}

output "project_name" {
  value = var.project_name
}

output "environment" {
  value = var.environment
}
