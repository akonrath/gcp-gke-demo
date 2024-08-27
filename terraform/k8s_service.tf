resource "kubernetes_service_v1" "default" {
  metadata {
    name = var.app_name
    annotations = {
      "cloud.google.com/neg" = jsonencode(
        {
          ingress = true
        }
      )
    }
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.default.spec[0].selector[0].match_labels.app
    }


    port {
      port        = 80
      target_port = kubernetes_deployment_v1.default.spec[0].template[0].spec[0].container[0].port[0].name
    }

    type = "LoadBalancer"
  }

  depends_on = [time_sleep.wait_service_cleanup]
}
