#output "ingress_ip" {
#  value = azurerm_public_ip.ingress.ip_address
#}

output "resource_group_name" {
  value = data.azurerm_resource_group.main.name
}

#output "appi_instrumentation_key" {
#  value = azurerm_application_insights.monitoring.instrumentation_key
#  sensitive = true
#}

#output "fq_image_name" {
#  value = "${azurerm_container_registry.main.login_server}/${local.image.repository}"
#}

output "image_tag" {
  value = local.image.tag
}

output "project_name" {
  value = var.project_name
}

output "environment" {
  value = var.environment
}

#output "ingress_name" {
#  value = cloudflare_record.prodyna-wtf.hostname
#}
