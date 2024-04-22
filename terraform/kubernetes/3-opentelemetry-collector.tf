# Install OpenTelemetry Collector
# Enable log collection
# Send traces, metrics and logs to Azure Monitor

# resource "kubernetes_namespace" "observability" {
#   metadata {
#     name = "observability"
#   }
# }
#
# resource "kubernetes_secret" "azuremonitorr" {
#   metadata {
#     name      = "azuremonitor"
#     namespace = kubernetes_namespace.observability.metadata[0].name
#   }
#   data = {
#     "AZURE_MONITOR_INSTRUMENTATION_KEY" = data.terraform_remote_state.azure.outputs.app_instrumentation_key
#   }
#   type = "Opaque"
# }
#
#
# # https://artifacthub.io/packages/helm/opentelemetry-helm/opentelemetry-collector
# resource "helm_release" "opentelemetry-collector" {
#   repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
#   chart            = "opentelemetry-collector"
#   name             = "opentelemetry-collector"
#   namespace        = kubernetes_namespace.observability.metadata[0].name
#   version          = "0.86.1"
#   create_namespace = false
#   force_update     = true
#
#   values = [file("assets/opentelemetry-collector/helm-values.yaml")]
# }
