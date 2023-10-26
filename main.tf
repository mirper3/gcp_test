provider "google" {
    project = var.project_id
    region  = var.region
    credentials = "creds.json"
}

data "google_compute_zones" "gcp-region" {
    region  = var.region
    project = var.project_id
}

locals {
    type   = ["public", "private"]
    zones = data.google_compute_zones.gcp-region.names
}

resource "google_compute_network" "vpc-network-tf" {
  name = "${var.name}-vpc-01"
  delete_default_routes_on_create = false
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "vpc-subnetwork-tf"{
    name = "${var.name}-subnet-01"
    network =google_compute_network.vpc-network-tf.id
    ip_cidr_range = "10.0.0.0/24"
    region = var.region
}

resource "google_compute_firewall" "fw-rule1" {
    name = "${var.name}-allow-ssh"
    network = google_compute_network.vpc-network-tf.id
    source_ranges = ["195.20.153.0/24"]
    priority = 1000
    direction = "INGRESS"
    allow {
      protocol = "tcp"
      ports = ["22"]
    }
}
resource "google_compute_firewall" "fw-rule2" {
    name = "${var.name}-allow-ssh-api"
    network = google_compute_network.vpc-network-tf.id
    source_ranges = ["35.235.240.0/20"]
    priority = 1001
    direction = "INGRESS"
    allow {
      protocol = "tcp"
      ports = ["22"]
    }
}

resource "google_compute_firewall" "fw-rule3" {
    name = "${var.name}-allow-icmp"
    network = google_compute_network.vpc-network-tf.id
    source_ranges = ["0.0.0.0/0"]
    priority = 45000
    direction = "INGRESS"
    allow {
      protocol = "icmp"
    }
}
resource "google_compute_firewall" "fw-rule4" {
    name = "${var.name}-allow-all-tcp-80"
    network = google_compute_network.vpc-network-tf.id
    source_ranges = ["0.0.0.0/0"]
    priority = 45001
    direction = "INGRESS"
    allow {
      protocol = "tcp"
      ports = ["80"]
    }
}

resource "google_compute_firewall" "fw-rule5" {
    name = "${var.name}-allow-hc"
    network = google_compute_network.vpc-network-tf.id
    source_ranges = ["209.85.152.0/22","35.191.0.0/16","209.85.204.0/22"]
    priority = 45001
    direction = "INGRESS"
    allow {
      protocol = "tcp"
      ports = ["32769"]
    }
}

resource "google_compute_global_address" "pip" {
  project      = var.project_id
  name         = "${var.name}-pip-01"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_compute_address" "vm-pip-01" {
  name   = "${var.name}-vm-pip-01"
  region = "${var.region}"
}

resource "google_compute_address" "vm-pip-02" {
  name   = "${var.name}-vm-pip-02"
  region = "${var.region}"
}

resource "google_compute_instance" "vm01" {
  name = "${var.name}-vm-01"
  zone = "${var.region}-a"
  machine_type = "n2-standard-4"
  network_interface {
    network = google_compute_network.vpc-network-tf.name
    subnetwork = google_compute_subnetwork.vpc-subnetwork-tf.name
    access_config {
      nat_ip = google_compute_address.vm-pip-01.address
    }
  }
  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20231010"
      size = 20
    }
  }
  metadata = {
    serial-port-enable = true
    "ssh-keys" = <<EOT
      vm_admin:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrewcFnbdZbzY6iH9VnaNBLU+omX2W4fuCDtdzQ5sg9RaCsqQk2soZN41Y4DniyxIDtLrAP8X++39Xf27RWJeo0i+VuzPs7YjSR4G9MQREJDlSg1AKw8LOLUi7rtVMoyq3JMTE9a6WrRZgfDmTxv4RghN0aG68l+QiabnkBPknPoyUqCpS99X4UJXkc8LGyNYrQ62r9iL53xE9oXiKieMKgPzLpMTdsu/K+R9IAUqr3uyxX6umcFqbsZs/3ET/1C7Avwgm26GxBZpkU6JozmSbhoPLK8rZUyI7m9y0GqMQvpeRl13Yvp6z2tjQIiJs/OcyhmnZZT10PFFp4TZ1TV4l rsa-key-20231025
     EOT
  }
  metadata_startup_script = file("script.sh")
}

resource "google_compute_instance" "vm02" {
  name = "${var.name}-vm-02"
  zone = "${var.region}-b"
  machine_type = "n2-standard-2"
  network_interface {
    network = google_compute_network.vpc-network-tf.name
    subnetwork = google_compute_subnetwork.vpc-subnetwork-tf.name
    access_config {
      nat_ip = google_compute_address.vm-pip-02.address
    }
  }
  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20231010"
      size = 20
    }
  }
  metadata = {
    serial-port-enable = true
    "ssh-keys" = <<EOT
      vm_admin:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrewcFnbdZbzY6iH9VnaNBLU+omX2W4fuCDtdzQ5sg9RaCsqQk2soZN41Y4DniyxIDtLrAP8X++39Xf27RWJeo0i+VuzPs7YjSR4G9MQREJDlSg1AKw8LOLUi7rtVMoyq3JMTE9a6WrRZgfDmTxv4RghN0aG68l+QiabnkBPknPoyUqCpS99X4UJXkc8LGyNYrQ62r9iL53xE9oXiKieMKgPzLpMTdsu/K+R9IAUqr3uyxX6umcFqbsZs/3ET/1C7Avwgm26GxBZpkU6JozmSbhoPLK8rZUyI7m9y0GqMQvpeRl13Yvp6z2tjQIiJs/OcyhmnZZT10PFFp4TZ1TV4l rsa-key-20231025
     EOT
  }
  metadata_startup_script = file("script.sh")
}

resource "google_compute_http_health_check" "hceck" {
  name = "${var.name}-hc"
  timeout_sec = 1
  check_interval_sec = 1
  port = "32769"
}

resource "google_compute_instance_group" "ig1" {
  name = "${var.name}-ig-${var.region}-a"
  zone = "${var.region}-a"
  named_port {
    name = "ngix"
    port = "32769"
  }
  instances = [google_compute_instance.vm01.id
  ]
}

resource "google_compute_instance_group" "ig2" {
  name = "${var.name}-ig-${var.region}-b"
  zone = "${var.region}-b"
  named_port {
    name = "ngix"
    port = "32769"
  }
  instances = [google_compute_instance.vm02.id
  ]
}

resource "google_compute_backend_service" "bckend" {
  name = "${var.name}-bcknd-ser-01"
  health_checks = [google_compute_http_health_check.hceck.id]
  protocol = "HTTP"
  port_name = "ngix"
  session_affinity = "NONE"
  timeout_sec = 30
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group.ig1.self_link
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
  backend {
    group = google_compute_instance_group.ig2.self_link
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  } 
}

resource "google_compute_target_http_proxy" "httpproxy" {
  name = "${var.name}-httpproxy-01"
  url_map = google_compute_url_map.urlmap.id
}

resource "google_compute_url_map" "urlmap" {
  name = "${var.name}-url-map"
  default_service = google_compute_backend_service.bckend.id

}

resource "google_compute_global_forwarding_rule" "fwd_rule" {
  name = "${var.name}-fwd-rule-01"
  #backend_service = google_compute_backend_service.bckend.id
  target = google_compute_target_http_proxy.httpproxy.id
  port_range = "80-80"
  ip_protocol = "TCP"
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_global_address.pip.id
}
