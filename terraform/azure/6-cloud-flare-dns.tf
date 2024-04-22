# resource "cloudflare_record" "prodyna-wtf" {
#   zone_id = var.cloudflare_zone_id
#   name    = var.project_name
#   value   = azurerm_public_ip.ingress.ip_address
#   type    = "A"
#   ttl     = 3600
# }
