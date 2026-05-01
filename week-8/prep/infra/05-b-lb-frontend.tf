# Client -> Static IP -> Fwd Rule -> HTTP Proxy -> URL Map (URL Map chooses backend service)


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
# Resource: Reserve Regional Static IP Address
resource "google_compute_address" "lb" {
  name = "lb-static-ip"
  # region = "" (optional if provider default is set)
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule
# Resource: Regional Forwarding Rule
# Defines how incoming traffic is forwarded to the load balancer proxy based on port and protocol
resource "google_compute_forwarding_rule" "lb" {
  name = "lb-forwarding-rule"
  # region = "" (optional if provider default is set)

  # We are sending traffic to a HTTP Proxy as this is an application LB
  target = google_compute_region_target_http_proxy.lb.self_link

  # Listen for traffic on Port 80 using TCP
  port_range            = "80"
  ip_protocol           = "TCP"
  ip_address            = google_compute_address.lb.address
  load_balancing_scheme = "EXTERNAL_MANAGED" # Current Gen LB (not classic)

  # Regional LB have forwaring rules that are scoped to a VPC
  network = google_compute_network.main.id

  # During the destroy process, we need to ensure LB is deleted first, before proxy-only subnet
  depends_on = [google_compute_subnetwork.regional_proxy_subnet]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_http_proxy
# Resource: Regional HTTP Proxy
# Acts as the HTTP frontend proxy that uses the URL map to decide where to send traffic.
# This resource's behavior takes place in the proxy only subnet
resource "google_compute_region_target_http_proxy" "lb" {
  name = "lb-http-proxy"
  # region = "" (optional if provider default is set)

  # URL Map is declared below
  url_map = google_compute_region_url_map.lb.self_link
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map
# Resource: Regional URL Map
# Maps incoming HTTP request URLs to backend services.
# We only use one backend service here so we simply set a default service and have the URL map route all traffic to it.
resource "google_compute_region_url_map" "lb" {
  name = "lb-url-map"

  # region = "us-central1"
  default_service = google_compute_region_backend_service.lb.self_link
}

