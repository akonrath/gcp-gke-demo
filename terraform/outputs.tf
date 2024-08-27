output "mongodb_private_ip" {
  value = google_compute_instance.mongodb.network_interface.0.network_ip
}
output "mongodb_public_ip" {
  value = google_compute_instance.mongodb.network_interface.0.access_config.0.nat_ip
}
