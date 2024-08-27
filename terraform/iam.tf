resource "google_service_account" "mongodb" {
  account_id   = "mongodb"
  display_name = "mongodb"
}

resource "google_project_iam_member" "mongodb" {
  project = data.google_project.project.project_id
  role    = "roles/storage.admin"
  member  = google_service_account.mongodb.member
}

resource "google_project_iam_member" "mongodb_admin" {
  project = data.google_project.project.project_id
  role    = "roles/resourcemanager.organizationAdmin"
  member  = google_service_account.mongodb.member
}

resource "google_project_service" "iam" {
  service                    = "iam.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = false
}

resource "google_service_account" "cluster" {
  account_id   = "${var.environment}-gke-cluster"
  display_name = "${var.environment}-gke-cluster"
  depends_on   = [google_project_service.iam]
}

resource "google_project_iam_member" "cluster" {
  for_each = toset(local.cluster_service_account_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.cluster.email}"
}
