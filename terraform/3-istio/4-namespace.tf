resource "kubernetes_namespace_v1" "bookinfo" {
  metadata {
    name = "bookinfo"
    labels = {
      #"istio.io/rev" = "asm-1-23" # Must match the revision label of the ASM installation
      "istio-injection" = "enabled"
    }
  }
  depends_on = [
    kubernetes_namespace_v1.istio-system
  ]
}
