resource "kubernetes_namespace" "bookstore" {
  metadata {
    name = "bookstore"
  }
}