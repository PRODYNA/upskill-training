# resource "kubernetes_manifest" "gateway_bookinfo_gateway_external" {
#   manifest = {
#     "apiVersion" = "networking.istio.io/v1beta1"
#     "kind" = "Gateway"
#     "metadata" = {
#       "name" = "bookinfo-gateway-external"
#       "namespace" = kubernetes_namespace_v1.bookinfo.metadata[0].name
#     }
#     "spec" = {
#       "selector" = {
#         "istio" = "aks-istio-ingressgateway-external"
#       }
#       "servers" = [
#         {
#           "hosts" = [
#             "*",
#           ]
#           "port" = {
#             "name" = "http"
#             "number" = 80
#             "protocol" = "HTTP"
#           }
#         },
#       ]
#     }
#   }
# }
#
# resource "kubernetes_manifest" "virtualservice_bookinfo_vs_external" {
#   manifest = {
#     "apiVersion" = "networking.istio.io/v1beta1"
#     "kind" = "VirtualService"
#     "metadata" = {
#       "name" = "bookinfo-vs-external"
#       "namespace" = kubernetes_namespace_v1.bookinfo.metadata[0].name
#     }
#     "spec" = {
#       "gateways" = [
#         "bookinfo-gateway-external",
#       ]
#       "hosts" = [
#         "*",
#       ]
#       "http" = [
#         {
#           "match" = [
#             {
#               "uri" = {
#                 "exact" = "/productpage"
#               }
#             },
#             {
#               "uri" = {
#                 "prefix" = "/static"
#               }
#             },
#             {
#               "uri" = {
#                 "exact" = "/login"
#               }
#             },
#             {
#               "uri" = {
#                 "exact" = "/logout"
#               }
#             },
#             {
#               "uri" = {
#                 "prefix" = "/api/v1/products"
#               }
#             },
#           ]
#           "route" = [
#             {
#               "destination" = {
#                 "host" = "productpage"
#                 "port" = {
#                   "number" = 9080
#                 }
#               }
#             },
#           ]
#         },
#       ]
#     }
#   }
# }
