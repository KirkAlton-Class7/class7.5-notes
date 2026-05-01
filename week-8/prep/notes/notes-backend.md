URL Map (google_compute_region_url_map.lb)
  │
  ▼
Backend Service (google_compute_region_backend_service.lb)
  │
  ├─ Uses: Regional Health Check (google_compute_region_health_check.lb)
  │
  ▼
Instance Group (google_compute_region_instance_group_manager.app)
  └─ Actual backend VMs serving your app (e.g., nginx, Flask, etc.)

Backend Service
This is the connection point between the ALB and your backend VMs:

It defines:

The protocol used between the proxy and backend (HTTP for ALB in this project).

The load balancing scheme (must be EXTERNAL_MANAGED for regional ALBs).

The port your app listens on (port_name = "webserver").

The backend group (a managed instance group for us).

The health check to determine VM readiness.

It receives the traffic after the proxy decides which service to send to, based on the URL map.





------------

HC
This is used by the backend service to continuously monitor the health of each VM in the instance group:

It sends HTTP requests (e.g., GET /index.html on port 80) to the backend VMs.

Only healthy VMs will receive traffic.

This ensures the ALB routes traffic only to responsive and healthy instances.