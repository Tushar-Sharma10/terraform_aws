resource "kubernetes_deployment" "web_app" {
  metadata {
    name = "web-application"
    labels = {
      app = "web-application"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "web-application"
      }
    }

    template {
      metadata {
        labels = {
          app = "web-application"
        }
      }

      spec {
        container {
          name  = "web-application"
          image = "tusharsharma01/web-app:latest"

          port {
            container_port = 80
          }
          resources {
            requests = {
              cpu    = "500m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
          }
        }
      }
    }
  }
}
