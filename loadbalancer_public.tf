/**
 * Copyright 2020 Quortex
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# The Quortex public IP used for public HTTP(S) load balancing.
resource "google_compute_global_address" "public" {
  # google beta required for labels atm.
  provider = google-beta

  name        = var.public_ip_name
  description = var.public_ip_description

  address_type = "EXTERNAL"
  ip_version   = var.public_ip_version

  labels = var.labels
}

# The public HTTP forwarding rule.
# It is used to forward traffic to the public load balancer for HTTP load balancing.
resource "google_compute_global_forwarding_rule" "public_http" {
  # google beta required for labels atm.
  provider = google-beta

  name        = var.public_http_forwarding_rule_name
  description = var.public_http_forwarding_rule_description

  # The URL of the target resource to receive the matched traffic.
  target                = google_compute_target_http_proxy.public.self_link
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.public.address
  ip_protocol           = "TCP"
  port_range            = "80"

  labels = var.labels
}

# The public HTTP proxy
# It is used by one or more global forwarding rule to route incoming HTTP requests to the URL map.
resource "google_compute_target_http_proxy" "public" {
  name        = var.public_http_proxy_name
  description = var.public_http_proxy_description
  url_map     = google_compute_url_map.public.self_link
}

# The public HTTPS forwarding rule.
# It is used to forward traffic to the public load balancer for HTTPS load balancing.
resource "google_compute_global_forwarding_rule" "public_https" {
  # google beta required for labels atm.
  provider = google-beta

  name        = var.public_https_forwarding_rule_name
  description = var.public_https_forwarding_rule_description

  # The URL of the target resource to receive the matched traffic.
  target                = google_compute_target_https_proxy.public.self_link
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.public.address
  ip_protocol           = "TCP"
  port_range            = "443"

  labels = var.labels
}

# The public HTTPS proxy
# It is used by one or more global forwarding rule to route incoming HTTPS requests to the URL map.
resource "google_compute_target_https_proxy" "public" {
  name             = var.public_https_proxy_name
  description      = var.public_https_proxy_description
  url_map          = google_compute_url_map.public.self_link
  ssl_certificates = [for e in var.dns_records_public : google_compute_managed_ssl_certificate.public[e].self_link]
}

# The public UrlMap, used to route requests to Quortex backend service for public purpose.
resource "google_compute_url_map" "public" {
  name        = var.public_url_map_name
  description = var.public_url_map_description

  # The backend service or backend bucket to use when none of the given rules match.
  default_service = google_compute_backend_service.public.self_link
}

# The backend service associated to public loadbalancer.
resource "google_compute_backend_service" "public" {
  name        = var.public_backend_service_name
  description = var.public_backend_service_description

  load_balancing_scheme = "EXTERNAL"

  # health_checks = [google_compute_http_health_check.public.self_link]
  health_checks = [google_compute_health_check.public.self_link]

  # Whether or not Cloud CDN is enabled on the Backend Service.
  enable_cdn = false

  # The protocol for incoming requests.
  protocol = "HTTP"

  # The backend configuration.
  dynamic "backend" {
    for_each = var.public_backend_service_config

    content {
      group                        = lookup(backend.value, "group", null)
      description                  = lookup(backend.value, "description", null)
      balancing_mode               = lookup(backend.value, "balancing_mode", null)
      capacity_scaler              = lookup(backend.value, "capacity_scaler", null)
      max_connections              = lookup(backend.value, "max_connections", null)
      max_connections_per_instance = lookup(backend.value, "max_connections_per_instance", null)
      max_connections_per_endpoint = lookup(backend.value, "max_connections_per_endpoint", null)
      max_rate                     = lookup(backend.value, "max_rate", 10000)
      max_rate_per_instance        = lookup(backend.value, "max_rate_per_instance", null)
      max_rate_per_endpoint        = lookup(backend.value, "max_rate_per_endpoint", null)
      max_utilization              = lookup(backend.value, "max_utilization", null)
    }
  }
}

# The public backend service health check configuration.
resource "google_compute_health_check" "public" {
  name        = var.public_http_health_check_name
  description = var.public_http_health_check_description

  http_health_check {
    port         = var.public_http_health_check_config.port
    request_path = var.public_http_health_check_config.request_path
  }
}
