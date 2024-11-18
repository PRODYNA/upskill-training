resource "kubernetes_manifest" "gateway_bookinfo_bookinfo_gateway" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind" = "Gateway"
    "metadata" = {
      "annotations" = {
        "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz/ready"
        "service.beta.kubernetes.io/port_80_health-probe_port" = "15021"
        "service.beta.kubernetes.io/port_80_health-probe_protocol" = "http"
        "service.beta.kubernetes.io/azure-load-balancer-resource-group" = data.azurerm_resource_group.main.name

        "service.beta.kubernetes.io/azure-pip-name" = data.azurerm_public_ip.istio_ip.name
      }
      "name" = "bookinfo-gateway"
      "namespace" = "bookinfo"
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
          "hostname" = data.terraform_remote_state.azure.outputs.istio_name
        },
        {
          "allowedRoutes" = {
            "namespaces" = {
              "from" = "Same"
            }
          }
          "name" = "https"
          "port" = 443
          "protocol" = "HTTPS"
          "hostname" = data.terraform_remote_state.azure.outputs.istio_name
          "tls" = {
            "certificateRefs" = [
              {
                "group" = ""
                "kind" = "Secret"
                "name" = "bookinfo-tls"
              },
            ]
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "httproute_bookinfo_bookinfo" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind" = "HTTPRoute"
    "metadata" = {
      "name" = "bookinfo"
      "namespace" = "bookinfo"
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
