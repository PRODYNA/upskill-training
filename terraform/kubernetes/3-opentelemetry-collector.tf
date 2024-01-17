# Install OpenTelemetry Collector
# Enable log collection
# Send traces, metrics and logs to Azure Monitor

# https://artifacthub.io/packages/helm/opentelemetry-helm/opentelemetry-collector
resource "helm_release" "opentelemetry-collector" {
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  name             = "opentelemetry-collector"
  namespace        = "opentelemetry-collector"
  version          = "0.78.0"
  create_namespace = true
  force_update     = true
  
  values = [file("assets/opentelemetry-collector/helm-values.yaml")]
}
