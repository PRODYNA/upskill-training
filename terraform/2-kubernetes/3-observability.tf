# Install OpenTelemetry Collector
# Enable log collection
# Send traces, metrics and logs to Azure Monitor

resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}

resource "kubernetes_secret" "azuremonitor" {
  metadata {
    name      = "azuremonitor"
    namespace = kubernetes_namespace.observability.metadata[0].name
  }
  data = {
    "AZURE_MONITOR_INSTRUMENTATION_KEY" = data.azurerm_application_insights.application_insights.instrumentation_key
  }
  type = "Opaque"
}

resource "helm_release" "kube-prometheus-stack" {
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.observability.metadata[0].name
  version    = "73.2.0"
  create_namespace = false

  values = [
    file("assets/kube-prometheus-stack/helm-values.yaml")
  ]

  set {
    name  = "grafana.ingress.hosts[0]"
    value = data.terraform_remote_state.azure.outputs.traefik_name
  }

  // set the ingress tls host
  set {
    name  = "grafana.ingress.tls[0].hosts[0]"
    value = data.terraform_remote_state.azure.outputs.traefik_name
  }
}

# https://artifacthub.io/packages/helm/opentelemetry-helm/opentelemetry-collector
resource "helm_release" "opentelemetry-collector" {
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  name             = "opentelemetry-collector"
  namespace        = kubernetes_namespace.observability.metadata[0].name
  version          = "0.126.0"
  create_namespace = false
  force_update     = true

  values = [file("assets/opentelemetry-collector/helm-values.yaml")]
}
