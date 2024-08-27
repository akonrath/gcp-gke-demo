resource "kubernetes_service_account" "app" {
  metadata {
    name = var.app_name
  }
}
