resource "kubernetes_deployment_v1" "default" {
  metadata {
    name = var.app_name
  }

  spec {
    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        service_account_name = kubernetes_service_account.app.metadata[0].name
        container {
          image = "${google_artifact_registry_repository.registry.location}-docker.pkg.dev/${data.google_project.project.project_id}/${google_artifact_registry_repository.registry.repository_id}/${var.app_name}:${var.app_image_tag}"
          #          image = "us-docker.pkg.dev/google-samples/containers/gke/hello-app:2.0"
          name = "${var.app_name}-container"
          env {
            name  = "MONGODB_URI"
            value = "mongodb://${var.mongodb_app_username}:${var.mongodb_app_password}@${google_compute_instance.mongodb.network_interface.0.network_ip}:27017/${var.mongodb_app_db}?authSource=admin"
          }

          env {
            name  = "SECRET_KEY"
            value = "foo"
          }
          port {
            container_port = 8080
            name           = var.app_name
          }

          security_context {
            allow_privilege_escalation = true
            privileged                 = true
            read_only_root_filesystem  = true

            capabilities {
              add  = []
              drop = ["NET_RAW"]
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = var.app_name

            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }

        security_context {
          run_as_non_root = true

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        # Toleration is currently required to prevent perpetual diff:
        # https://github.com/hashicorp/terraform-provider-kubernetes/pull/2380
        toleration {
          effect   = "NoSchedule"
          key      = "kubernetes.io/arch"
          operator = "Equal"
          value    = "amd64"
        }
      }
    }
  }
}

