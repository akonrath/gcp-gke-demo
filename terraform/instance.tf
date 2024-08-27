resource "google_compute_instance" "mongodb" {
  name                      = "${var.environment}-mongodb"
  machine_type              = "e2-micro"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"

    }
  }

  network_interface {
    network = google_compute_network.vpc.id
    access_config {
    }
  }

  service_account {
    email  = google_service_account.mongodb.email
    scopes = ["cloud-platform"]
  }
  tags = ["${var.environment}-mongodb"]
  metadata = {
    "ssh-keys" = "ubuntu:${var.ssh_key}"
  }


  metadata_startup_script = <<EOT
sudo apt-get update
sudo apt-get install gnupg curl

# Install MongoDB 6
curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor
sudo echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl daemon-reload

# Bind to all interfaces to allow remote connectivity
sudo sed -i 's/bindIp:.*/bindIp: 0.0.0.0/g' /etc/mongod.conf
sudo systemctl start mongod
sudo systemctl enable mongod


# Create app and admin users and load them into the admin database with mongosh
sudo echo 'db.createUser(
  {
    user: "${var.mongodb_app_username}",
  pwd: "${var.mongodb_app_password}",
    roles: [{ role: "readWrite", db: "${var.mongodb_app_db}"}]
});' > /home/ubuntu/mongodb_${var.mongodb_app_username}.js
sudo echo 'db.createUser({
    user: "${var.mongodb_admin_username}",
    pwd: "${var.mongodb_admin_password}",
    roles: [{role: "backup", db: "admin" }, { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase"]
});' > /home/ubuntu/mongodb_admin.js
sudo /usr/bin/mongosh admin /home/ubuntu/mongodb_admin.js
sudo /usr/bin/mongosh admin /home/ubuntu/mongodb_${var.mongodb_app_username}.js

# Enable authentication to allow remote access
sudo echo 'security:
  authorization: enabled' >> /etc/mongod.conf
sudo systemctl restart mongod


# Add a script to take dumps of all databases and upload to storage bucket
sudo echo '
pushd /home/ubuntu/
mongodump --username="${var.mongodb_admin_username}" --password="${var.mongodb_admin_password}"
gcloud storage cp --recursive dump/ gs://${google_storage_bucket.mongodb_backups.name}/$(date +%s)
rm -rf dump/
popd' > /home/ubuntu/mongodb_backup.sh
chmod +x /home/ubuntu/mongodb_backup.sh

# Add a cron to run the backup script every 30 minutes
sudo echo '*/30 * * * * ubuntu /bin/bash /home/ubuntu/mongodb_backup.sh' > /etc/cron.d/mongodb
EOT

}
