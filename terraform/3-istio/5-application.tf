resource "kubernetes_manifest" "service_details" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "details"
        "service" = "details"
      }
      "name" = "details"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "port" = 9080
        },
      ]
      "selector" = {
        "app" = "details"
      }
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_bookinfo_details" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "account" = "details"
      }
      "name" = "bookinfo-details"
    }
  }
}

resource "kubernetes_manifest" "deployment_details_v1" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "details"
        "version" = "v1"
      }
      "name" = "details-v1"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app"     = "details"
          "version" = "v1"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app"     = "details"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image"           = "docker.io/istio/examples-bookinfo-details-v1:1.20.2"
              "imagePullPolicy" = "IfNotPresent"
              "name"            = "details"
              "ports" = [
                {
                  "containerPort" = 9080
                },
              ]
            },
          ]
          "serviceAccountName" = "bookinfo-details"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_ratings" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "ratings"
        "service" = "ratings"
      }
      "name" = "ratings"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "port" = 9080
        },
      ]
      "selector" = {
        "app" = "ratings"
      }
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_bookinfo_ratings" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "account" = "ratings"
      }
      "name" = "bookinfo-ratings"
    }
  }
}

resource "kubernetes_manifest" "deployment_ratings_v1" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "ratings"
        "version" = "v1"
      }
      "name" = "ratings-v1"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app"     = "ratings"
          "version" = "v1"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app"     = "ratings"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image"           = "docker.io/istio/examples-bookinfo-ratings-v1:1.20.2"
              "imagePullPolicy" = "IfNotPresent"
              "name"            = "ratings"
              "ports" = [
                {
                  "containerPort" = 9080
                },
              ]
            },
          ]
          "serviceAccountName" = "bookinfo-ratings"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_reviews" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "reviews"
        "service" = "reviews"
      }
      "name" = "reviews"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "port" = 9080
        },
      ]
      "selector" = {
        "app" = "reviews"
      }
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_bookinfo_reviews" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "account" = "reviews"
      }
      "name" = "bookinfo-reviews"
    }
  }
}

resource "kubernetes_manifest" "deployment_reviews_v1" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "reviews"
        "version" = "v1"
      }
      "name" = "reviews-v1"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app"     = "reviews"
          "version" = "v1"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app"     = "reviews"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "LOG_DIR"
                  "value" = "/tmp/logs"
                },
              ]
              "image"           = "docker.io/istio/examples-bookinfo-reviews-v1:1.20.2"
              "imagePullPolicy" = "IfNotPresent"
              "name"            = "reviews"
              "ports" = [
                {
                  "containerPort" = 9080
                },
              ]
              "volumeMounts" = [
                {
                  "mountPath" = "/tmp"
                  "name"      = "tmp"
                },
                {
                  "mountPath" = "/opt/ibm/wlp/output"
                  "name"      = "wlp-output"
                },
              ]
            },
          ]
          "serviceAccountName" = "bookinfo-reviews"
          "volumes" = [
            {
              "emptyDir" = {}
              "name"     = "wlp-output"
            },
            {
              "emptyDir" = {}
              "name"     = "tmp"
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_reviews_v2" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "reviews"
        "version" = "v2"
      }
      "name" = "reviews-v2"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app"     = "reviews"
          "version" = "v2"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app"     = "reviews"
            "version" = "v2"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "LOG_DIR"
                  "value" = "/tmp/logs"
                },
              ]
              "image"           = "docker.io/istio/examples-bookinfo-reviews-v2:1.20.2"
              "imagePullPolicy" = "IfNotPresent"
              "name"            = "reviews"
              "ports" = [
                {
                  "containerPort" = 9080
                },
              ]
              "volumeMounts" = [
                {
                  "mountPath" = "/tmp"
                  "name"      = "tmp"
                },
                {
                  "mountPath" = "/opt/ibm/wlp/output"
                  "name"      = "wlp-output"
                },
              ]
            },
          ]
          "serviceAccountName" = "bookinfo-reviews"
          "volumes" = [
            {
              "emptyDir" = {}
              "name"     = "wlp-output"
            },
            {
              "emptyDir" = {}
              "name"     = "tmp"
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_reviews_v3" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "reviews"
        "version" = "v3"
      }
      "name" = "reviews-v3"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app"     = "reviews"
          "version" = "v3"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app"     = "reviews"
            "version" = "v3"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "LOG_DIR"
                  "value" = "/tmp/logs"
                },
              ]
              "image"           = "docker.io/istio/examples-bookinfo-reviews-v3:1.20.2"
              "imagePullPolicy" = "IfNotPresent"
              "name"            = "reviews"
              "ports" = [
                {
                  "containerPort" = 9080
                },
              ]
              "volumeMounts" = [
                {
                  "mountPath" = "/tmp"
                  "name"      = "tmp"
                },
                {
                  "mountPath" = "/opt/ibm/wlp/output"
                  "name"      = "wlp-output"
                },
              ]
            },
          ]
          "serviceAccountName" = "bookinfo-reviews"
          "volumes" = [
            {
              "emptyDir" = {}
              "name"     = "wlp-output"
            },
            {
              "emptyDir" = {}
              "name"     = "tmp"
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_productpage" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "productpage"
        "service" = "productpage"
      }
      "name" = "productpage"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "port" = 9080
        },
      ]
      "selector" = {
        "app" = "productpage"
      }
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_bookinfo_productpage" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "account" = "productpage"
      }
      "name" = "bookinfo-productpage"
    }
  }
}

resource "kubernetes_manifest" "deployment_productpage_v1" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.bookinfo.metadata.0.name
      "labels" = {
        "app"     = "productpage"
        "version" = "v1"
      }
      "name" = "productpage-v1"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app"     = "productpage"
          "version" = "v1"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "prometheus.io/path"   = "/metrics"
            "prometheus.io/port"   = "9080"
            "prometheus.io/scrape" = "true"
          }
          "labels" = {
            "app"     = "productpage"
            "version" = "v1"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image"           = "docker.io/istio/examples-bookinfo-productpage-v1:1.20.2"
              "imagePullPolicy" = "IfNotPresent"
              "name"            = "productpage"
              "ports" = [
                {
                  "containerPort" = 9080
                },
              ]
              "volumeMounts" = [
                {
                  "mountPath" = "/tmp"
                  "name"      = "tmp"
                },
              ]
            },
          ]
          "serviceAccountName" = "bookinfo-productpage"
          "volumes" = [
            {
              "emptyDir" = {}
              "name"     = "tmp"
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "podmonitor_bookinfo_istio_sidecars" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PodMonitor"
    "metadata" = {
      "name"      = "istio-sidecars"
      "namespace" = "bookinfo"
    }
    "spec" = {
      "podMetricsEndpoints" = [
        {
          "path" = "/stats/prometheus"
          "port" = "http-envoy-prom"
        },
      ]
      "selector" = {
        "matchLabels" = {
          "security.istio.io/tlsMode" = "istio"
        }
      }
    }
  }
}