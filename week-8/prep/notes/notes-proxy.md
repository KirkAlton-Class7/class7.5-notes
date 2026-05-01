proxy only subnet is a special-purpose regional subnet used by Google Cloud's External HTTP(S) Load Balancer (regional) to host Google-managed proxy instances.

Client ──▶ Static IP ──▶ Forwarding Rule ──▶ [ Google-managed Proxy VM(s) ]
                                                 │
                                                 ▼
                                        URL Map → Backend
                            (Running inside proxy-only subnet)


Google Cloud uses Google-managed proxy instances (running in the proxy-only subnet) to terminate client connections and handle L7 (Layer 7) logic like:

TLS termination (for HTTPS)

URL-based routing

Header manipulation

Session affinity

Logging and monitoring

These proxies are built on Envoy, an open-source edge and service proxy
