provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "gitlab" {
  name         = "gitlab"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["gitlab"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size = "${var.disk_size}"
    }
  }

  network_interface {
    network = "default"

    access_config = {}
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

}

resource "google_compute_firewall" "firewall_gitlab" {
  name    = "allow-gitlab-http-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gitlab"]
}
