Client request → hits static IP (google_compute_address.lb).

That IP is used by the forwarding rule (google_compute_forwarding_rule.lb).

The rule sends the request to the regional HTTP proxy (google_compute_region_target_http_proxy.lb).

The proxy uses the URL map (google_compute_region_url_map.lb) to pick the backend.

Finally, traffic is routed to the backend service.

Client -> Static IP -> Fwd Rule -> HTTP Proxy -> URL Map (URL Map chooses backend service)
               ┌─────────────────────────────┐
               │     Client (Browser, etc.)  │
               └────────────┬────────────────┘
                            │
                            ▼
         ┌────────────────────────────────────────┐
         │ Reserved Static IP (google_compute_     │
         │ address.lb) — e.g., 35.123.45.67        │
         └────────────────┬───────────────────────┘
                          │
                          ▼
       ┌────────────────────────────────────────────┐
       │ Forwarding Rule (google_compute_forwarding_rule.lb) │
       │ - Listens on port 80                           │
       │ - Targets HTTP Proxy                           │
       └────────────────┬──────────────────────────────┘
                        │
                        ▼
       ┌──────────────────────────────────────────┐
       │ HTTP Proxy (google_compute_region_target_http_proxy.lb) │
       │ - Uses URL map for routing               │
       └────────────────┬─────────────────────────┘
                        │
                        ▼
       ┌─────────────────────────────────────────────┐
       │ URL Map (google_compute_region_url_map.lb)  │
       │ - Matches path rules (or default_service)   │
       │ - Forwards to Backend Service               │
       └────────────────┬────────────────────────────┘
                        │
                        ▼
       ┌────────────────────────────────────────────┐
       │ Backend Service (e.g., MIG, GCE, GKE, etc.) │
       │ Not shown here, but referenced in URL map  │
       └────────────────────────────────────────────┘



