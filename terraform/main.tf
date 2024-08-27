terraform {
  required_version = "~> 1.0"

  required_providers {
    google = {
      version = "~> 5.0"
      source  = "hashicorp/google"
    }
    kubernetes = {
      version = "~> 2.0"
      source  = "hashicorp/kubernetes"
    }
  }
}

provider "google" {
  region = var.region
  zone   = var.zone
}
provider "kubernetes" {
  host                   = "https://${google_container_cluster.cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)

  //  ignore_annotations = [
  //    "^autopilot\\.gke\\.io\\/.*",
  //    "^cloud\\.google\\.com\\/.*"
  //  ]
}
