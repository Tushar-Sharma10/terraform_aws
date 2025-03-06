resource "kubernetes_service" "my_app_service" {
  metadata {
    name = "web-app-service"
  }

  spec {
    selector = {
      app = "web-application"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}
