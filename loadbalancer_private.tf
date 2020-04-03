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

# The Quortex private IP used for private HTTP(S) load balancing.
resource "google_compute_global_address" "private" {
  # google beta required for labels atm.
  provider = google-beta

  name        = var.private_ip_name
  description = var.private_ip_description

  address_type = "EXTERNAL"
  ip_version   = var.private_ip_version

  labels = var.labels
}

# The private HTTP forwarding rule.
# It is used to forward traffic to the private load balancer for HTTP load balancing.
resource "google_compute_global_forwarding_rule" "private_http" {
  # google beta required for labels atm.
  provider = google-beta

  name        = var.private_http_forwarding_rule_name
  description = var.private_http_forwarding_rule_description

  # The URL of the target resource to receive the matched traffic.
  target                = google_compute_target_http_proxy.private.self_link
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.private.address
  ip_protocol           = "TCP"
  port_range            = "80"

  labels = var.labels
}

# The private http proxy
# It is used by one or more global forwarding rule to route incoming HTTP requests to the URL map.
resource "google_compute_target_http_proxy" "private" {
  name        = var.private_http_proxy_name
  description = var.private_http_proxy_description
  url_map     = google_compute_url_map.private.self_link
}

# The private HTTPS forwarding rule.
# It is used to forward traffic to the private load balancer for HTTPS load balancing.
resource "google_compute_global_forwarding_rule" "private_https" {
  # google beta required for labels atm.
  provider = google-beta

  name        = var.private_https_forwarding_rule_name
  description = var.private_https_forwarding_rule_description

  # The URL of the target resource to receive the matched traffic.
  target                = google_compute_target_https_proxy.private.self_link
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.private.address
  ip_protocol           = "TCP"
  port_range            = "443"

  labels = var.labels
}

# The private https proxy
# It is used by one or more global forwarding rule to route incoming HTTPS requests to the URL map.
resource "google_compute_target_https_proxy" "private" {
  name        = var.private_https_proxy_name
  description = var.private_https_proxy_description

  url_map          = google_compute_url_map.private.self_link
  ssl_certificates = [for k, v in var.dns_records_private : google_compute_managed_ssl_certificate.private[k].self_link]
}

# The private UrlMap, used to route requests to Quortex backend service for private purpose.
resource "google_compute_url_map" "private" {
  name        = var.private_url_map_name
  description = var.private_url_map_description

  # The backend service or backend bucket to use when none of the given rules match.
  default_service = google_compute_backend_service.private.self_link
}

# The backend service associated to private loadbalancer.
resource "google_compute_backend_service" "private" {
  name        = var.private_backend_service_name
  description = var.private_backend_service_description

  load_balancing_scheme = "EXTERNAL"

  health_checks = [google_compute_health_check.private.self_link]

  # Whether or not Cloud CDN is enabled on the Backend Service.
  enable_cdn = false

  # The protocol for incoming requests.
  protocol = "HTTP"

  # The backend configuration.
  dynamic "backend" {
    for_each = var.private_backend_service_config

    content {
      group                        = lookup(backend.value, "group", null)
      description                  = lookup(backend.value, "description", null)
      balancing_mode               = lookup(backend.value, "balancing_mode", null)
      capacity_scaler              = lookup(backend.value, "capacity_scaler", null)
      max_connections              = lookup(backend.value, "max_connections", null)
      max_connections_per_instance = lookup(backend.value, "max_connections_per_instance", null)
      max_connections_per_endpoint = lookup(backend.value, "max_connections_per_endpoint", null)
      max_rate                     = lookup(backend.value, "max_rate", null)
      max_rate_per_instance        = lookup(backend.value, "max_rate_per_instance", null)
      max_rate_per_endpoint        = lookup(backend.value, "max_rate_per_endpoint", null)
      max_utilization              = lookup(backend.value, "max_utilization", null)
    }
  }

  security_policy = google_compute_security_policy.policy.self_link
}

# The private backend service health check configuration.
resource "google_compute_health_check" "private" {
  name        = var.private_http_health_check_name
  description = var.private_http_health_check_description

  http_health_check {
    port         = var.private_http_health_check_config.port
    request_path = var.private_http_health_check_config.request_path
  }
}

# The security policy associated to private loadbalancer.
# Set the IP ranges whitelisted for private loadbalancer access.
resource "google_compute_security_policy" "policy" {
  name        = var.private_security_policy_name
  description = var.private_security_policy_description

  # Reject all traffic that hasn't been whitelisted.
  rule {
    action   = "deny(403)"
    priority = "2147483647"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "Default rule, higher priority overrides it"
  }

  # Whitelist traffic from certain ip address
  rule {
    action   = "allow"
    priority = "1000"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = var.private_security_policy_whitelisted_ips
      }
    }

    description = "whitelisted IP ranges"
  }
}
