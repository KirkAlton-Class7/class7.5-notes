Client
  └─▶ Hits Static IP (reserved)
        └─▶ Forwarding Rule (port 80, TCP)
              └─▶ GCP-managed Envoy Proxy (in proxy-only subnet)
                    └─▶ Uses URL Map to select Backend Service
                          └─▶ Validates healthy backends using Health Check
                                └─▶ Forwards to healthy VMs in Instance Group


-------

+--------------------------+
|      Client Browser      |
|   (Sends HTTP request)   |
+------------+-------------+
             |
             ▼
+--------------------------+
|  Regional Static IP      |  <-- google_compute_address.lb
|  (e.g., 35.123.45.67)    |
+------------+-------------+
             |
             ▼
+--------------------------+
|  Forwarding Rule         |  <-- google_compute_forwarding_rule.lb
|  - TCP:80                |
|  - EXTERNAL_MANAGED LB   |
+------------+-------------+
             |
             ▼
+--------------------------+  <-- HTTP Proxy
|  Envoy Proxy VM(s)       |  <-- In Proxy-Only Subnet
|  (Google-managed layer 7 |
|   proxies running Envoy) |
+------------+-------------+
             |
             ▼
+--------------------------+
|  URL Map                 |  <-- google_compute_region_url_map.lb
|  - Routes paths to       |
|    specific backends     |
+------------+-------------+
             |
             ▼
+--------------------------+
|  Backend Service         |  <-- google_compute_region_backend_service.lb
|  - Protocol: HTTP        |
|  - Port: webserver       |
|  - Load Balancing: UTIL  |
|  - Health Check linked   |
+------------+-------------+
             |
             | Health check traffic (internal from GCP infra)
             ▼
+--------------------------+
|  Regional Health Check   |  <-- google_compute_region_health_check.lb
|  - Path: /index.html     |
|  - Port: 80              |
+------------+-------------+
             |
             ▼
+--------------------------+
|  Instance Group          |  <-- google_compute_region_instance_group_manager.app
|  - VM Template (Startup) |
|  - App listens on port 80|
+--------------------------+

Legend:
- Solid arrows: user-request traffic flow
- Dashed arrow: health check probe (internal)
