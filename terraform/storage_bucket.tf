resource "google_storage_bucket" "mongodb_backups" {
  name                        = "${var.environment}-mongodb-backups"
  storage_class               = "REGIONAL"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "public" {
  bucket = google_storage_bucket.mongodb_backups.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
