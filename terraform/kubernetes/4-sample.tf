# Prepare namespace for the application
resource "kubernetes_namespace" "sample" {
  metadata {
      name = "sample"
  }
}
