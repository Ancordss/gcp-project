 # ConfigMap
resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name      = var.configmap_name
    namespace = var.namespace
  }

  data = {
    "default.conf" = <<EOT
      server {
        listen 80;
        location / {
          proxy_pass http://backend:80;
        }
      }
    EOT
  }
}

# Deployment
resource "kubernetes_deployment" "proxy" {
  metadata {
    name      = var.deployment_name
    namespace = var.namespace
    labels = {
      app = var.deployment_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.deployment_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.deployment_name
        }
      }

      spec {
        container {
          name  = var.deployment_name
          image = var.image

          volume_mount {
            name       = var.configmap_name
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path   = "default.conf"
          }

          port {
            container_port = var.loadbalancer_port
          }

          resources {
            requests = {
              cpu    = var.cpu_requests
              memory = var.memory_requests
            }
            limits = {
              cpu    = var.cpu_limits
              memory = var.memory_limits
            }
          }
        }

        volume {
          name = var.configmap_name

          config_map {
            name = kubernetes_config_map.nginx_config.metadata[0].name
          }
        }
      }
    }
  }
}

# Service
resource "kubernetes_service" "proxy" {
  metadata {
    name      = var.service_name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.deployment_name
    }

    port {
      protocol    = "TCP"
      port        = var.loadbalancer_port
      target_port = var.loadbalancer_port
    }

    type = "LoadBalancer"
  }
}

# Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "proxy_hpa" {
  metadata {
    name      = var.hpa_name
    namespace = var.namespace
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.proxy.metadata[0].name
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    metric {
      type = "Resource"
      resource {
        name                 = "cpu"
        target {
          type                 = "Utilization"
          average_utilization  = 50
        }
      }
    }

    metric {
      type = "Resource"
      resource {
        name                 = "memory"
        target {
          type                 = "Utilization"
          average_utilization  = 50
        }
      }
    }
  }
}
