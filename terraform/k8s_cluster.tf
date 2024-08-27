resource "google_container_cluster" "cluster" {
  name                     = "${var.environment}-cluster"
  deletion_protection      = false
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.id

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_node_pool" "node_pool" {
  name       = "${var.environment}-node-pool-01"
  cluster    = google_container_cluster.cluster.name
  node_count = 1

  node_config {
    preemptible     = true
    machine_type    = "e2-small"
    tags            = [google_container_cluster.cluster.name]
    service_account = google_service_account.cluster.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "time_sleep" "wait_service_cleanup" {
  depends_on = [google_container_cluster.cluster]

  destroy_duration = "180s"
}
