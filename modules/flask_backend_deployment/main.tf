resource "kubernetes_deployment" "app" {
  metadata {
    name = var.name
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          name  = var.name
          image = var.image
          port {
            container_port = var.port
          }
          env {
            name  = "FLASK_SERVER_PORT"
            value = var.flask_server_port
          }
          resources {
            requests = var.backend_container_resources.requests
            limits   = var.backend_container_resources.limits
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = var.name
    labels = {
      app = var.name
    }
  }

  spec {
    selector = {
      app = var.name
    }

    port {
      port        = var.port
      target_port = var.port
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "app_hpa" {
  metadata {
    name = "${var.name}-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.name
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

# Variables
