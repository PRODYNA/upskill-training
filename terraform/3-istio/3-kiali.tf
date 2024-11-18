resource "helm_release" "kiali" {
   name       = "kiali-server"
   repository = "https://kiali.org/helm-charts"
   chart      = "kiali-server"
   namespace  = kubernetes_namespace_v1.istio-system.metadata[0].name
   version    = "2.1.0"

   values = [
       file("helm/kiali-server.yaml"),
   ]

   set {
      name = "external_services.grafana.external_url"
      value = "https://${data.terraform_remote_state.azure.outputs.traefik_name}/grafana"
   }
}
