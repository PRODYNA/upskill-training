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
  name       = "istio-istiod"
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

resource "helm_release" "istio-cni" {
    name       = "istio-cni"
    repository = local.helm.repository.istio
    chart      = "cni"
    namespace  = kubernetes_namespace_v1.istio-system.metadata.0.name
    version    = "1.24.0"

    values = [
        file("helm/istio-cni.yaml"),
    ]

    depends_on = [
        helm_release.istiod
    ]
}

resource "helm_release" "istio-ztunnel" {
    name       = "istio-ztunnel"
    repository = local.helm.repository.istio
    chart      = "ztunnel"
    namespace  = kubernetes_namespace_v1.istio-system.metadata.0.name
    version    = "1.24.0"

    values = [
        file("helm/istio-ztunnel.yaml"),
    ]

    depends_on = [
        helm_release.istio-cni
    ]
}

resource "kubernetes_manifest" "servicemonitor_istio_system_istiod" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "ServiceMonitor"
    "metadata" = {
      "name"      = "istiod"
      "namespace" = "istio-system"
    }
    "spec" = {
      "endpoints" = [
        {
          "interval" = "15s"
          "port"     = "http-monitoring"
        },
      ]
      "namespaceSelector" = {
        "matchNames" = [
          "istio-system",
        ]
      }
      "selector" = {
        "matchLabels" = {
          "istio" = "pilot"
        }
      }
    }
  }
}