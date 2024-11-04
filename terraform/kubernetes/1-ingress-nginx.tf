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
  version          = "v4.11.3"
  force_update     = true
  create_namespace = false

  # helm -n ingress-nginx upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.9.1 -f assets/ingress-nginx/helm-values.yaml --set a=1 --set a=2

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
