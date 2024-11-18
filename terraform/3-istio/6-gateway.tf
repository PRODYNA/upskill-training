resource "kubernetes_manifest" "bookinfo_gateway" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind"       = "Gateway"
    "metadata" = {
      "annotations" = {
        "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz/ready"
        "service.beta.kubernetes.io/port_80_health-probe_port"                     = "15021"
        "service.beta.kubernetes.io/port_80_health-probe_protocol"                 = "http"
        "service.beta.kubernetes.io/port_443_health-probe_port"                    = "15021"
        "service.beta.kubernetes.io/port_443_health-probe_protocol"                = "http"
        "service.beta.kubernetes.io/port_15021_no_lb_rule"                         = "true"
        "service.beta.kubernetes.io/azure-load-balancer-resource-group"            = data.azurerm_resource_group.main.name
        "cert-manager.io/issuer"                                                   = "letsencrypt-istio"
        "service.beta.kubernetes.io/azure-pip-name"                                = data.azurerm_public_ip.istio_ip.name
      }
      "name"      = "bookinfo-gateway"
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
          "name"     = "http"
          "port"     = 80
          "protocol" = "HTTP"
          "hostname" = data.terraform_remote_state.azure.outputs.istio_name
        },
        {
          "allowedRoutes" = {
            "namespaces" = {
              "from" = "Same"
            }
          }
          "name"     = "https"
          "port"     = 443
          "protocol" = "HTTPS"
          "hostname" = data.terraform_remote_state.azure.outputs.istio_name
          "tls" = {
            "certificateRefs" = [
              {
                "group" = ""
                "kind"  = "Secret"
                "name"  = "bookinfo-tls"
              },
            ]
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "bookinfo_http_route" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind"       = "HTTPRoute"
    "metadata" = {
      "name"      = "bookinfo-http"
      "namespace" = "bookinfo"
    }
    "spec" = {
      hostnames = [
        data.terraform_remote_state.azure.outputs.istio_name
      ]
      "parentRefs" = [
        {
          "name" = "bookinfo-gateway"
          "sectionName" = "http"
        },
      ]
      "rules" = [
        {
          "filters" = [
            {
              "type" = "RequestRedirect"
              "requestRedirect" = {
                "scheme"     = "https"
                "statusCode" = 301
              }
            }
          ]
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "bookinfo_https_route" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind"       = "HTTPRoute"
    "metadata" = {
      "name"      = "bookinfo-https"
      "namespace" = "bookinfo"
    }
    "spec" = {
      hostnames = [
        data.terraform_remote_state.azure.outputs.istio_name
      ]
      "parentRefs" = [
        {
          "name" = "bookinfo-gateway"
          "sectionName" = "https"
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
                "type"  = "Exact"
                "value" = "/productpage"
              }
            },
            {
              "path" = {
                "type"  = "PathPrefix"
                "value" = "/static"
              }
            },
            {
              "path" = {
                "type"  = "Exact"
                "value" = "/login"
              }
            },
            {
              "path" = {
                "type"  = "Exact"
                "value" = "/logout"
              }
            },
            {
              "path" = {
                "type"  = "PathPrefix"
                "value" = "/api/v1/products"
              }
            },
          ]
        },
      ]
    }
  }
}
