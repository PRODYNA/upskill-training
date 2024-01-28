#resource "kubernetes_namespace" "cert-manager" {
#  metadata {
#    name = "cert-manager"
#  }
#}
#
## https://artifacthub.io/packages/helm/cert-manager/cert-manager
#resource "helm_release" "cert_manager" {
#  repository       = "https://charts.jetstack.io"
#  chart            = "cert-manager"
#  name             = "cert-manager"
#  namespace        = kubernetes_namespace.cert-manager.metadata[0].name
#  version          = "1.13.3"
#  create_namespace = false
#  force_update     = true
#  set {
#    name  = "installCRDs"
#    value = "true"
#  }
#}