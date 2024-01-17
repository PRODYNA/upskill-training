resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

# https://kubernetes.github.io/ingress-nginx/
resource "helm_release" "ingress_nginx" {
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  name             = "ingress-nginx"
  namespace        = kubernetes_namespace.ingress-nginx.metadata[0].name
  version          = "v4.9.0"
  force_update     = true
  create_namespace = false

  set {
    name  = "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path\""
    value = "/healthz"
  }
  set {
    name  = "controller.service.loadBalancerIP"
    value = data.azurerm_public_ip.ingress.ip_address
  }
  set {
    name  = "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group\""
    value = data.azurerm_resource_group.main.name
  }

  values = [
    file("assets/ingress-nginx/helm-values.yaml")
  ]
}
