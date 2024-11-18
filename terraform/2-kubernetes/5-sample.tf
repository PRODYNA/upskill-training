# Prepare namespace for the application
resource "kubernetes_namespace" "sample" {
  metadata {
    name = "sample"
  }
}
## Deploy the application
resource "helm_release" "sample" {
  name      = "sample"
  chart     = "../../helm/sample"
  namespace = kubernetes_namespace.sample.metadata[0].name
  set {
    name  = "image.repository"
    value = data.terraform_remote_state.azure.outputs.fq_image_name
  }
  set {
    name  = "image.tag"
    value = data.terraform_remote_state.azure.outputs.image_tag
  }

  // set the ingress name
  set {
    name  = "ingress.hosts[0].host"
    value = data.terraform_remote_state.azure.outputs.traefik_name
  }

  // set the ingress tls host
  set {
    name  = "ingress.tls[0].hosts[0]"
    value = data.terraform_remote_state.azure.outputs.traefik_name
  }

  values = [
    file("assets/sample/helm-values.yaml")
  ]
}
