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
  version          = "35.2.0"
  force_update     = false
  create_namespace = false

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = data.azurerm_resource_group.main.name
  }

  set {
    name = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-pip-name"
    value = data.azurerm_public_ip.traefik.name
  }


  set {
    name  = "service.loadBalancerIP"
    value = data.azurerm_public_ip.traefik.ip_address
  }

  values = [
    file("assets/traefik/helm-values.yaml")
  ]
}
