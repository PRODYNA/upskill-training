# https://artifacthub.io/packages/helm/cert-manager/cert-manager
resource "helm_release" "cert_manager" {
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  name             = "cert-manager"
  namespace        = "cert-manager"
  version          = "1.13.3"
  create_namespace = true
  force_update     = true
  set {
    name  = "installCRDs"
    value = "true"
  }
}