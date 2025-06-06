resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

# https://kubernetes.github.io/ingress-nginx/
resource "helm_release" "traefik" {
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  name             = "traefik"
  namespace        = kubernetes_namespace.traefik.metadata[0].name
  version          = "35.4.0"
  force_update     = false
  create_namespace = false

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    # lowercase to avoid issues with the dot in the name
    value = lower(data.azurerm_resource_group.main.name)
  }

  set {
    name = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-pip-name"
    value = lower(data.azurerm_public_ip.traefik.name)
  }

  // --set
  set {
    name  = "service.loadBalancerIP"
    value = lower(data.azurerm_public_ip.traefik.ip_address)
  }

  // -f
  values = [
    file("assets/traefik/helm-values.yaml")
  ]
}
