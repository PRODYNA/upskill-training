resource "cloudflare_dns_record" "prodyna-wtf" {
  zone_id = var.cloudflare_zone_id
  name    = var.project_name
  content = azurerm_public_ip.ingress.ip_address
  type    = "A"
  ttl     = 3600
  proxied = false

}

resource "cloudflare_dns_record" "prodyna-wtf-istio" {
  zone_id = var.cloudflare_zone_id
  name    = "${var.project_name}.istio"
  content = azurerm_public_ip.istio.ip_address
  type    = "A"
  ttl     = 3600
  proxied = false
}