# Prepare namespace for the application
resource "kubernetes_namespace" "sample" {
  metadata {
      name = "sample"
  }
}

# Deploy the application
resource "helm_release" "sample" {
  name = "sample"
  chart = "../../helm/sample"
  namespace = kubernetes_namespace.sample.metadata[0].name
  set {
    name = "image.repository"
    value = data.terraform_remote_state.azure.outputs.fq_image_name
  }
  set {
    name = "image.tag"
    value = data.terraform_remote_state.azure.outputs.image_tag
  }
  values = [
    file("assets/sample/helm-values.yaml")
  ]
}
