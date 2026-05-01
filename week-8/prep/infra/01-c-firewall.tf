# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall

# Direct SSH Access for Lizzo lovers
# For main VPC
resource "google_compute_firewall" "ssh" {
  name    = "${google_compute_network.main.name}-allow-lizzo-ssh"
  network = google_compute_network.main.name
  #direction = "INGRESS" (not needed as it is a default value- see API documentation)

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-backend"]
}


# Lizzo's ping FW rule
resource "google_compute_firewall" "ping" {
  name    = "${google_compute_network.main.name}-allow-ping"
  network = google_compute_network.main.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ping-backend"]
}


#####

resource "google_compute_firewall" "allow_hc" {
  name = "fw-allow-health-check"

  allow {
    protocol = "tcp"
  }

  direction     = "INGRESS"
  network       = google_compute_network.main.id
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["load-balanced-backend"]
}



resource "google_compute_firewall" "allow_proxy" {
  name = "fw-allow-proxies"

  allow {
    ports    = ["443"]
    protocol = "tcp"
  }

  allow {
    ports    = ["80"]
    protocol = "tcp"
  }

  allow {
    ports    = ["8080"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  network       = google_compute_network.main.id
  priority      = 1000
  source_ranges = [google_compute_subnetwork.regional_proxy_subnet.ip_cidr_range]
  target_tags   = ["load-balanced-backend"]
}