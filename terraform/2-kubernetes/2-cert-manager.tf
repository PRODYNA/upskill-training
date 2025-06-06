resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

# https://artifacthub.io/packages/helm/cert-manager/cert-manager
resource "helm_release" "cert_manager" {
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  name             = "cert-manager"
  namespace        = kubernetes_namespace.cert-manager.metadata[0].name
  version          = "1.17.2"
  create_namespace = false
  force_update     = true

  values = [
    file("assets/cert-manager/helm-values.yaml")
  ]
}

resource "helm_release" "clusterissuer-traefik" {
  repository       = "https://snowplow-devops.github.io/helm-charts"
  chart            = "cert-manager-issuer"
  version          = "0.1.0"
  name             = "letsencrypt-traefik"
  namespace        = kubernetes_namespace.cert-manager.metadata[0].name
  create_namespace = false
  depends_on = [
    helm_release.cert_manager
  ]
  values = [
    file("assets/cert-manager-issuer-traefik/helm-values.yaml")
  ]
}
