provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "dockerhost" {
  count        = "${var.count}"
  name         = "reddit-docker-host-${count.index + 1}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-docker-host"]

  boot_disk {
    initialize_params {
      image = "${var.docker_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {}
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

# Дожидаемся ответа от инстанса
  provisioner "remote-exec" {
    inline = ["echo 'Hello from host ${count.index + 1}'"]
  }

}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-docker-host"]
}

# Провижининг ожидает завершения основного задания
# Можно отключить, передав переменной do_provision = false
resource "null_resource" "provisioners" {
  depends_on = ["google_compute_instance.dockerhost"]
  count = "${var.do_provision}"

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_HOST_KEY_CHECKING=False \
      ANSIBLE_ROLES_PATH=../ansible/roles \
      ansible-playbook \
      --skip-tags predeploy \
      -u appuser \
      -i ../ansible/environments/stage/gce.py \
      --private-key ${var.private_key_path} \
      ../ansible/playbooks/deploy.yml
    EOF
  }
}
