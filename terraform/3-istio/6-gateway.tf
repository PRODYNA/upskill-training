resource "kubernetes_manifest" "gateway_bookinfo_gateway" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind" = "Gateway"
    "metadata" = {
      "name" = "bookinfo-gateway"
      namespace = kubernetes_namespace_v1.bookinfo.metadata.0.name
    }
    "spec" = {
      "gatewayClassName" = "istio"
      "listeners" = [
        {
          "allowedRoutes" = {
            "namespaces" = {
              "from" = "Same"
            }
          }
          "name" = "http"
          "port" = 80
          "protocol" = "HTTP"
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "httproute_bookinfo" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind" = "HTTPRoute"
    "metadata" = {
      "name" = "bookinfo"
      namespace = kubernetes_namespace_v1.bookinfo.metadata.0.name
    }
    "spec" = {
      "parentRefs" = [
        {
          "name" = "bookinfo-gateway"
        },
      ]
      "rules" = [
        {
          "backendRefs" = [
            {
              "name" = "productpage"
              "port" = 9080
            },
          ]
          "matches" = [
            {
              "path" = {
                "type" = "Exact"
                "value" = "/productpage"
              }
            },
            {
              "path" = {
                "type" = "PathPrefix"
                "value" = "/static"
              }
            },
            {
              "path" = {
                "type" = "Exact"
                "value" = "/login"
              }
            },
            {
              "path" = {
                "type" = "Exact"
                "value" = "/logout"
              }
            },
            {
              "path" = {
                "type" = "PathPrefix"
                "value" = "/api/v1/products"
              }
            },
          ]
        },
      ]
    }
  }
}
