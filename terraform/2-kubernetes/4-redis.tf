resource "kubernetes_namespace" "redis" {
  metadata {
    name = "redis"
  }
}

resource "helm_release" "redis" {
  name       = "redis"
  chart = "oci://registry-1.docker.io/bitnamicharts/redis"
  namespace  = kubernetes_namespace.redis.metadata.0.name
  version    = "20.13.4"
  set {
    name  = "auth.enabled"
    value = "false"
  }
}
