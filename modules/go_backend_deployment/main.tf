resource "kubernetes_namespace" "app3" {
  metadata {
    name = var.namespace_name
  }
}

## Deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_namespace.app3.metadata[0].name
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
          image = var.container_image

          port {
            container_port = var.container_port
          }

          resources {
            requests = var.resource_requests
            limits   = var.resource_limits
          }
        }
      }
    }
  }
}

# Service
resource "kubernetes_service" "backend" {
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_namespace.app3.metadata[0].name
  }

  spec {
    selector = {
      app = var.deployment_name
    }

    port {
      protocol    = "TCP"
      port        = var.container_port
      target_port = var.container_port
    }

    type = "ClusterIP"
  }
}

# Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "backend_hpa" {
  metadata {
    name      = "${var.deployment_name}-hpa"
    namespace = kubernetes_namespace.app3.metadata[0].name
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.backend.metadata[0].name
    }

    min_replicas = var.hpa_min_replicas
    max_replicas = var.hpa_max_replicas

    metric {
      type = "Resource"
      resource {
        name                 = "cpu"
        target {
          type                 = "Utilization"
          average_utilization  = var.hpa_cpu_utilization
        }
      }
    }

    metric {
      type = "Resource"
      resource {
        name                 = "memory"
        target {
          type                 = "Utilization"
          average_utilization  = var.hpa_memory_utilization
        }
      }
    }
  }
}