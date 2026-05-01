# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_health_check
# Resource: Regional Health Check
resource "google_compute_region_health_check" "lb" {
  name = "lb-health-check"
  # region = "us-central1"

  # How often in seconds the HC checks and waits for failure/success
  check_interval_sec = 5
  timeout_sec        = 5

  # Consecutive success and failure required to determine health
  healthy_threshold   = 2
  unhealthy_threshold = 3

  # Set health check to type HTTP and set endpoint to test
  http_health_check {
    request_path = "/index.html"
    port         = 80
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service
# Resource: Regional Backend Service
resource "google_compute_region_backend_service" "lb" {
  name = "lb-backend-service"
  # region = "" (optional if provider default is set)

  # Backend service is for an application and uses HTTP
  protocol = "HTTP"

  # External LB and fully managed (next gen type, not classic)
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_region_health_check.lb.self_link]

  # Named port from MIG
  port_name = "webserver"

  # Use console defaults for this
  backend {
    group           = google_compute_region_instance_group_manager.app.instance_group
    capacity_scaler = 1.0
    balancing_mode  = "UTILIZATION"
  }
}