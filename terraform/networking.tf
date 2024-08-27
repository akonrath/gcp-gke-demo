resource "google_compute_network" "vpc" {
  name                    = "${var.environment}-vpc"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.environment}-ssh"
  network = google_compute_network.vpc.name


  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "icmp" {
  name    = "${var.environment}-icmp"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "internal" {
  name    = "${var.environment}-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  source_ranges = ["10.128.0.0/9"]

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "mongodb" {
  name    = "${var.environment}-mongodb"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }
  //  source_tags = [google_container_cluster.cluster.name]
  //  target_tags = [google_compute_instance.mongodb.name]
  source_ranges = ["0.0.0.0/0"]
}
