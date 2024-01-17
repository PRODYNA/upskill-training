# Install OpenTelemetry Collector
# Enable log collection
# Send traces, metrics and logs to Azure Monitor

resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}

resource "kubernetes_secret" "opentelemetry-collector" {
  metadata {
    name      = "opentelemetry-collector-instrumentation-key"
    namespace = kubernetes_namespace.opentelemetry-collector.metadata[0].name
  }
  data = {
    "instrumentation-key" = data.terraform_remote_state.azure.outputs.appi_instrumentation_key
  }
  type = "Opaque"
}


# https://artifacthub.io/packages/helm/opentelemetry-helm/opentelemetry-collector
resource "helm_release" "opentelemetry-collector" {
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  name             = "opentelemetry-collector"
  namespace        = kubernetes_namespace.observability.metadata[0].name
  version          = "0.78.0"
  create_namespace = false
  force_update     = true
  
  values = [file("assets/opentelemetry-collector/helm-values.yaml")]
}
