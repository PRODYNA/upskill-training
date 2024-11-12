resource "kubernetes_namespace_v1" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio-base" {
  name       = "istio-base"
  repository = local.helm.repository.istio
  chart      = "base"
  namespace  = kubernetes_namespace_v1.istio-system.metadata.0.name
  version    = "1.24.0"

  values = [
      file("helm/istio-base.yaml"),
    ]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = local.helm.repository.istio
  chart      = "istiod"
  namespace  = kubernetes_namespace_v1.istio-system.metadata.0.name
  version    = "1.24.0"

  values = [
    file("helm/istiod.yaml"),
  ]

  depends_on = [
    helm_release.istio-base
  ]
}
