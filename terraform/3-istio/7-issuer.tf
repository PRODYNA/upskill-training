resource "kubernetes_manifest" "issuer-istio" {
  manifest = yamldecode(file("manifest/issuer.yaml"))
}