# modules/mongo_deployment/main.tf
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

