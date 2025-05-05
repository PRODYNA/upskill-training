# output "resource_group" {
#   value = azurerm_resource_group.main
# }
#
# output "kubernetes_cluster" {
#   value     = azurerm_kubernetes_cluster.main
#   sensitive = true
# }
#
# output "log_analytics_workspace" {
#   value     = azurerm_log_analytics_workspace.monitoring
#   sensitive = true
# }
#
# output "application_insights" {
#   value     = azurerm_application_insights.monitoring
#   sensitive = true
# }
#
# output "container_registry" {
#   value     = azurerm_container_registry.main
#   sensitive = true
# }
#
# output "traefik_ip" {
#   value = azurerm_public_ip.ingress
# }
#
# output "istio_ip" {
#   value = azurerm_public_ip.istio
# }
#
# output "subscription_id" {
#   value = data.azurerm_client_config.current.subscription_id
# }
#
# output "resource_group_name" {
#   value = azurerm_resource_group.main.name
# }
#
# output "fq_image_name" {
#   value = "${azurerm_container_registry.main.login_server}/${local.image.repository}"
# }
#
# output "image_tag" {
#   value = local.image.tag
# }
#
# output "project_name" {
#   value = var.project_name
# }
#
# output "traefik_name" {
#   value = "${var.project_name}.prodyna.wtf"
# }
#
# output "istio_name" {
#   value = "${var.project_name}.istio.prodyna.wtf"
# }
