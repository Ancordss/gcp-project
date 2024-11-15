resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name = "nginx-config"
  }

  data = {
    "nginx.conf" = <<-EOT
      server {
        listen 80;
        location / {
          proxy_pass http://backend:9091;
        }
      }
    EOT
  }
}

resource "kubernetes_deployment" "web" {
  metadata {
    name = "web"
    labels = {
      app = "web"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "web"
      }
    }

    template {
      metadata {
        labels = {
          app = "web"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx"
          port {
            container_port = 80
          }
          env {
            name  = "FLASK_SERVER_ADDR"
            value = "backend:9091"
          }
          volume_mount {
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path   = "nginx.conf"
            name       = "nginx-config-volume"
          }
          resources {
            requests = var.container_resources.requests
            limits   = var.container_resources.limits
          }
        }

        volume {
          name = "nginx-config-volume"
          config_map {
            name = kubernetes_config_map.nginx_config.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "web" {
  metadata {
    name = "web"
    labels = {
      app = "web"
    }
  }

  spec {
    selector = {
      app = "web"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

# resource "kubernetes_manifest" "istio_gateway" {
#   manifest = {
#     apiVersion = "networking.istio.io/v1alpha3"
#     kind       = "Gateway"
#     metadata = {
#       name      = "web-gateway"
#       namespace = "default"
#     }
#     spec = {
#       selector = {
#         istio = "ingressgateway" # Selecciona el gateway por defecto de Istio
#       }
#       servers = [
#         {
#           port = {
#             number   = 80
#             name     = "http"
#             protocol = "HTTP"
#           }
#           hosts = ["*"]
#         }
#       ]
#     }
#   }
# }

# # Configuración del VirtualService para redirigir el tráfico al servicio "web"
# resource "kubernetes_manifest" "istio_virtual_service" {
#   manifest = {
#     apiVersion = "networking.istio.io/v1alpha3"
#     kind       = "VirtualService"
#     metadata = {
#       name      = "web-service"
#       namespace = "default"
#     }
#     spec = {
#       hosts    = ["*"]
#       gateways = ["web-gateway"]
#       http = [
#         {
#           match = [
#             {
#               uri = {
#                 prefix = "/"
#               }
#             }
#           ]
#           route = [
#             {
#               destination = {
#                 host = kubernetes_service.web.metadata[0].name
#                 port = {
#                   number = 80
#                 }
#               }
#             }
#           ]
#         }
#       ]
#     }
#   }
# }

resource "kubernetes_horizontal_pod_autoscaler_v2" "web_hpa" {
  metadata {
    name = "web-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "web"
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                 = "Utilization"
          average_utilization  = var.cpu_target_utilization
        }
      }
    }
  }
}

